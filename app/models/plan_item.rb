class PlanItem < ApplicationRecord
  belongs_to :recipe
  belongs_to :plan
end
