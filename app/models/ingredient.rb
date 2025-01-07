class Ingredient < ApplicationRecord
  belongs_to :recipe

  [StringCleaner, BrandScrubber].each do
    normalizes :name, :text, :sentence, with: it
  end

  def marked_up_text
    attrs_to_markup = [
      :name,
      :amount,
      :size,
      :preparation,
      :comment,
      :purpose,
    ]

    text.dup.tap do |markup|
      attrs_to_markup.each do |attr|
        val = self[attr]
        next if val.blank?

        escaped_attr = Regexp.escape(val)
        css_classes = "ingredient-part ingredient-#{attr}"
        markup.gsub!(/#{escaped_attr}/i, "<span class=\"#{css_classes}\">\\0</span>")
      end
    end
  end
end
