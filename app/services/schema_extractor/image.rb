module SchemaExtractor
  class Image < Base
    def process
      return unless extracted.present?

      first_pass = case extracted
       when Hash
         extracted["url"] || extracted["contentUrl"]
       when Array
         extracted.first
       else
         extracted
       end

      case first_pass
      when Hash
        first_pass["url"] || first_pass["contentUrl"]
      when Array
        first_pass.first
      else
        first_pass
      end
    end
  end
end
