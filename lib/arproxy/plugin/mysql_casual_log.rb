require "arproxy"
require "mysql2"
require "term/ansicolor"

module Arproxy::Plugin
  class MysqlCasualLog < Arproxy::Base
    Arproxy::Plugin.register(:mysql_casual_log, self)

    REGEXPS = {
      'select_type' => Regexp.union(
        /DEPENDENT\sUNION/,
        /DEPENDENT\sSUBQUERY/,
        /UNCACHEABLE\sUNION/,
        /UNCACHEABLE\sSUBQUERY/
      ),
      'type' =>  Regexp.union(
        /index/,
        /ALL/
      ),
      'possible_keys' => Regexp.union(
        /NULL/
      ),
      'key' => Regexp.union(
        /NULL/
      ),
      'Extra' => Regexp.union(
        /Using\sfilesort/,
        /Using\stemporary/
      )
    }

    def initialize(*args)
      @options = args.first || {}
      @out = @options[:out] || $stdout
      @raw_connection = @options[:raw_connection] || proc {|conn, sql| conn.raw_connection }
    end

    def execute(sql, name=nil)
      if sql =~ /\ASELECT\b/i
        proxy(sql)
      end

      super(sql, name)
    end

    private

    def proxy(sql)
      if @raw_connection.respond_to?(:call)
        conn = @raw_connection.call(proxy_chain.connection, sql)
      else
        conn = @raw_connection
      end

      if conn
        explain(conn, sql)
      end
    end

    def explain(conn, sql)
      badquery = false
      explains = []

      conn.query("EXPLAIN #{sql}", :as => :hash).each_with_index do |result, i|
        colorize_explain(result).tap {|bq| badquery ||= bq }
        explains << format_explain(result, i + 1)
      end

      if badquery
        query_options = conn.query_options.dup
        query_options.delete(:password)

        @out << <<-EOS
# Time: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}
# Query options: #{query_options.inspect}
# Query: #{sql}
#{explains.join("\n")}
        EOS
      end
    rescue => e
      $stderr.puts colored([e.message, e.backtrace.first].join("\n"))
    end

    def colorize_explain(explain_result)
      badquery = false

      REGEXPS.each do |key, regexp|
        value = explain_result[key] ||= 'NULL'
        value = value.to_s

        value.gsub!(regexp) do |m|
          badquery = true
          colored(m)
        end
      end

      badquery
    end

    def colored(str)
      Term::ANSIColor.red(Term::ANSIColor.bold(str))
    end

    def format_explain(explain, i)
      message = "*************************** #{i}. row ***************************\n"
      max_key_length = explain.keys.map(&:length).max

      explain.each do |key, value|
        message << "%*s: %s\n" % [max_key_length, key, value]
      end

      message.chomp
    end
  end # CasualLog
end # Arproxy::Plugin
