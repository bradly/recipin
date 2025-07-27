require 'open3'
require 'json'

class IngredientParser
  attr_reader :string

  def initialize(string)
    @string = string
  end

  def parse
    raw_json = json_string

    # Sanitize the Python script output. Occasionally the underlying
    # `ingredient_parser` Python library triggers an on-the-fly NLTK download
    # when it is first used. The NLTK downloader writes progress information
    # such as "Downloading required NLTK resour..." to *STDOUT* **before** the
    # JSON payload is printed. Because `JSON.parse` expects the string to start
    # with a valid JSON token (`{` or `[`), the leading log lines cause a
    # `JSON::ParserError` ("unexpected character").

    cleaned_json = sanitize_output(raw_json)

    begin
      @parsed = JSON.parse(cleaned_json)
    rescue JSON::ParserError => e
      # Log enough context to diagnose the failure without leaking user data.
      Rails.logger.error("#{self.class.name} failed to parse JSON – #{e.message}")
      Rails.logger.debug("Sanitized JSON string (first 500 chars): #{cleaned_json[0..500]}")

      # Re-raise so upstream callers can handle the failure.
      raise e
    end
  end

  def parsed
    @parsed ||= parse
  end

  # Remove anything that appears *before* the first JSON opening delimiter.
  #
  # Example input (note the leading log line):
  #   "Downloading required NLTK resour...
  #   {\"name\": [\"flour\"], ...}"
  #
  # After sanitization the string begins with the opening `{` so
  # `JSON.parse` will succeed.
  #
  # We purposely keep trailing whitespace because the JSON parser ignores it,
  # and stripping it would risk truncating a legitimate space inside a JSON
  # string if the payload were somehow malformed.
  def sanitize_output(raw)
    return "" if raw.nil?

    # Find the first occurrence of either a JSON object or array opener.
    start_idx = raw.index(/[{\[]/)

    # If nothing looks like JSON just propagate the original string – the
    # caller will raise and we will log it for later inspection.
    return raw unless start_idx

    raw[start_idx..]
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
