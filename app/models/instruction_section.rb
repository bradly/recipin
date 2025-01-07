class InstructionSection < ApplicationRecord
  belongs_to :recipe
  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions
end
