require "aws-sdk-dynamodb"
require 'yaml'

module Alephant
  module Harness
    module Service
      module DynamoDB
        def self.create(table_name, schema)
          schema.tap { |s| s[:table_name] = table_name }
          client.create_table(schema)
        end

        def self.remove(table_name)
          client.delete_table({ :table_name => table_name })
        rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
          # If table doesn't exist fail silently
        end

        def self.load_schema(schema_name)
          YAML::load_file(File.join([File.dirname(__FILE__), *(%w'..' * 4), 'schema', "#{schema_name}.yaml"]))
        end

        private

        def self.client
          @@client ||= ::Aws::DynamoDB::Client.new(AWS.dynamo_config)
        end
      end
    end
  end
end
