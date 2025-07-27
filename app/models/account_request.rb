# frozen_string_literal: true

class AccountRequest < ApplicationRecord
  belongs_to :user,
             primary_key: :email_address,
             foreign_key: :email,
             optional: true

  scope :accepted,  -> { joins(:user) }
  scope :dismissed, -> { where(dismissed: true) }
  scope :pending,   -> { where(dismissed: false).left_joins(:user).where(users: { id: nil }) }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def accepted?
    user.present?
  end
end
