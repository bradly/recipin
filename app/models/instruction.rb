class Instruction < ApplicationRecord
  belongs_to :instruction_section

  normalizes :name, :text, with: TextCleaner
  normalizes :name, :text, with: BrandScrubber

  def to_s
    [name, text].compact_blank.join(" - ")
  end
end
