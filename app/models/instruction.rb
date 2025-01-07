class Instruction < ApplicationRecord
  belongs_to :recipe

  [TextCleaner, BrandScrubber].each do
    normalizes :name, :text, with: it
  end
end
