class FailedImport < ApplicationRecord
  scope :recent, -> { order(id: :desc) }

  def short_error
    error_message.to_s.truncate(120)
  end
end
