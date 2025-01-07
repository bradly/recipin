class Instruction < ApplicationRecord
  belongs_to :instruction_section

  normalizes :name, :text, with: TextCleaner
  normalizes :name, :text, with: BrandScrubber
end
