describe Arproxy::Plugin::MysqlCasualLog do
  before do
    allow_any_instance_of(Arproxy::Base).to receive(:execute)
  end

  let(:today) { Time.parse("2015-05-15 20:15:55 +0000") }
  let(:out) { StringIO.new }

  let(:raw_connection) do
    Mysql2::Client.new(host: "localhost", username: "root", database: "mysql")
  end

  let(:plugin) do
    Arproxy::Plugin::MysqlCasualLog.new(out: out, raw_connection: raw_connection)
  end

  describe "#initialize" do
    describe "@out" do
      subject { plugin.instance_variable_get(:@out) }
      it { is_expected.to eq out }
    end

    describe "@raw_connection" do
      subject { plugin.instance_variable_get(:@raw_connection) }
      it { is_expected.to eq raw_connection }
    end
  end

  describe "#execute" do
    subject { out.string.sub(/Query options:.*/, "Query options:").sub(/rows: \d+/, "rows:") }

    before do
      Timecop.freeze(today) do
        plugin.execute(sql)
      end
    end

    context "when bad query" do
      let(:sql) { "select * from user" }

      let(:explain) do
        <<-EOS
# Time: 2015-05-15 20:15:55
# Query options:
# Query: select * from user
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: user
         type: #{red bold "ALL"}
possible_keys: #{red bold "NULL"}
          key: #{red bold "NULL"}
      key_len:\s
          ref:\s
         rows:
        Extra:\s
        EOS
      end

      it { is_expected.to eq explain }
    end

    context "when bad query" do
      let(:sql) { "select 1 from user where Host = 'localhost'" }
      it { is_expected.to eq "" }
    end
  end
end
