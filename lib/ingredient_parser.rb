require 'open3'
require 'json'

class IngredientParser
  attr_reader :string

  def initialize(string)
    @string = string
  end

  def parse
    @parsed = JSON.parse(json_string)
  end

  def parsed
    @parsed ||= parse
  end

  def json_string
    begin
      output, error, status = Open3.capture3("./bin/ingredient_to_json.py", string)
      status.success? ? output : raise(error)
    rescue => e
      Rails.logger.error("#{self.class.name} error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise e
    end
  end

  def text
    @string
  end

  def name
    parsed.dig("name", 0)
  end

  def amount
    parsed.dig("amount", 0)
  end

  def size
    parsed.dig("size")
  end

  def preparation
    parsed.dig("preparation")
  end

  def comment
    parsed.dig("comment")
  end

  def purpose
    parsed.dig("purpose")
  end

  def sentence
    parsed.dig("sentence")
  end
end
