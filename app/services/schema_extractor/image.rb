module SchemaExtractor
  class Image < Base
    def process
      return unless extracted.present?

      case extracted
      when Hash
        value["url"]
      when Array
        value.first
      else
        value
      end
    end
  end
end
