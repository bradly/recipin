class Ingredient < ApplicationRecord
  belongs_to :recipe

  normalizes :name, :text, :sentence, with: StringCleaner
  normalizes :name, :text, :sentence, with: BrandScrubber
end
