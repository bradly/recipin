module SchemaExtractor
  class Ingredients < Base
    def process
      extracted = super
      return unless extracted.present?

      extracted.map do |text|
        data = Ingredient.find_by(text:) || IngredientParser.new(text)

        {
          text:,
          name: data.name,
          amount: data.amount,
          size: data.size,
          preparation: data.preparation,
          comment: data.comment,
          purpose: data.purpose,
          sentence: data.sentence,
        }
      end
    end
  end
end
