module SchemaExtractor
  class Base
    attr_reader :extracted

    def initialize(schema, keys = [])
      @schema = schema
      @keys = keys
    end

    def self.extract(...)
      new(...).extract
    end

    def keys
      Array.wrap(@keys).map(&:to_s)
    end

    def extract
      @extracted = keys.map { @schema.dig(_1) }.compact.first
      process
    end

    def process
      extracted
    end
  end
end
