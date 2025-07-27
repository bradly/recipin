class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Account request associations (matched on email address)
  has_many :account_requests,
           primary_key: :email_address,
           foreign_key: :email,
           inverse_of: :user

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  alias_attribute :email, :email_address
end
