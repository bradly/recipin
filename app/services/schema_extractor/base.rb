module SchemaExtractor
  class Base
    attr_reader :extracted

    def initialize(schema, *keys)
      @schema = schema
      @keys = keys
    end

    def self.extract(...)
      new(...).extract
    end

    def extract
      key = @keys.find { @schema[_1].presence }
      @extracted = @schema[key]
      process
    end

    def process; end

    def schema_dig(attr, keys = :text)
      keys = Array.wrap(keys).map(&:to_s)

      Array.wrap(schema.dig(attr.to_s).presence).collect do |value|
        case value
        when Hash
          value.slice(*keys).first
        when Array
          value.first
        else
          value
        end
      end
    end
  end
end
