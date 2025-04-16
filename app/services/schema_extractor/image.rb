module SchemaExtractor
  class Image < Base
    def process
      return unless extracted.present?

      case extracted
      when Hash
        extracted["url"]
      when Array
        extracted.first
      else
        extracted
      end
    end
  end
end
