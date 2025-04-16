require "iso8601"
require "action_view"

module SchemaExtractor
  class Duration < Base
    include ActionView::Helpers::DateHelper

    def process
      return unless extracted.present?

      duration = ISO8601::Duration.new(extracted)
      distance_of_time_in_words(Time.now, Time.now + duration.to_seconds)
    end
  end
end
