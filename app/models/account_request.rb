class AccountRequest < ApplicationRecord
  validates :email_address, presence: true
end
