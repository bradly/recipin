class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  module StringCleaner
    def self.call(value)
      # Normalize the string in **three** steps:
      # 1. Unescape any HTML entities (`&amp;` → `&`) so punctuation is literal.
      # 2. Strip out HTML tags so they don’t interfere with positional regexes.
      # 3. Trim leading commas/whitespace and trailing punctuation/whitespace.

      sanitized = ActionController::Base.helpers.strip_tags(
        CGI.unescapeHTML(value)
      )

      sanitized.remove(
        /\A[\s,]+/,   # leading spaces or commas
        /[\.,\s]+\z/ # trailing period/comma/space(s)
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
