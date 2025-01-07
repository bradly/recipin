require "iso8601"
require "action_view"

module SchemaExtractor
  class Duration < Base
    def process
      return unless extracted.present?

      duration = ISO8601::Duration.new(extracted)
      ActionView::Helpers::DateHelper.distance_of_time_in_words(Time.now, Time.now + duration.to_seconds)
    end
  end
end
