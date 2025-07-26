class FailedImport < ApplicationRecord
  # Simple utility scope for ordering newest first
  scope :recent, -> { order(created_at: :desc) }

  # Convenience method for safely extracting a truncated version of the error
  # message (used in table listings)
  def short_error
    error_message.to_s.truncate(120)
  end
end
