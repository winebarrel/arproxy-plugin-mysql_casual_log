# Arproxy::Plugin::CasualLog

Plug-in that colorize MySQL bad query for [Arproxy](https://github.com/cookpad/arproxy).
It is porting of [MySQLCasualLog.pm](https://gist.github.com/kamipo/839e8a5b6d12bddba539).

see http://kamipo.github.io/talks/20140711-mysqlcasual6

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arproxy-plugin-mysql_casual_log'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arproxy-plugin-mysql_casual_log

## Usage

```ruby
Arproxy.configure do |config|
   config.adapter = "mysql2"
  config.plugin :mysql_casual_log
end
```
