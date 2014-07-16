require 'spec_helper'

describe Alephant::Harness::Service::DynamoDB do

  describe ".create" do
    it "creates a table based off a schema" do

      table_name = 'test_lookup'
      schema_name = 'lookup'
      schema = subject.load_schema(schema_name)

      expected_schema = YAML::load_file(File.join(File.dirname(__FILE__), *[%w'..' * 2], 'schema', "#{schema_name}.yaml"))
      expected_schema[:table_name] = table_name

      expect_any_instance_of(AWS::DynamoDB::Client::V20120810).to receive(:create_table).with(expected_schema)
      subject.create(table_name, schema)

    end
  end

  describe ".delete" do
    let(:tables) { %w(foo bar) }

    context "When tables exist" do
      it "removes specified tables" do
        expect_any_instance_of(AWS::DynamoDB::Client::V20120810).to receive(:delete_table).twice
        tables.each do |table|
          subject.remove(table)
        end
      end
    end

    context "When tables don't exist" do
      it "Fails silently" do
        expect_any_instance_of(AWS::DynamoDB::Client::V20120810).to receive(:delete_table).and_raise(Exception)
        expect { subject.remove('blah') }.to_not raise_error(Exception)
      end
    end

  end

end

