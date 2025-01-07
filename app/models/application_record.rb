class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  module StringCleaner
    def self.call(value)
      removals = [
        /\A[\s,]+/,
        /[\.\s,]+\Z/,
      ]

      ActionController::Base.helpers.strip_tags(
        CGI.unescapeHTML(value.remove(*removals))
      )
    end
  end

  module TextCleaner
    def self.call(value)
      removals = [
        /(\s+)\Z/,
        /\A(\s+)/,
      ]
      value.remove(*removals)
    end
  end

  module BrandScrubber
    BRANDS = [
      /Land O Lakes®?/,
      "Diamond Crystal",
    ]

    def self.call(value)
      value.remove(*BRANDS)
    end
  end
end
