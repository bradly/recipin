# frozen_string_literal: true

require 'test_helper'

# Tests for the normalizer utility modules that live inside
# `ApplicationRecord`. These modules are used throughout the models to
# clean/normalize user-supplied strings before persistence.

class ApplicationRecordNormalizersTest < ActiveSupport::TestCase
  # Convenience aliases
  StringCleaner   = ApplicationRecord::StringCleaner
  TextCleaner     = ApplicationRecord::TextCleaner
  BrandScrubber   = ApplicationRecord::BrandScrubber

  # ------------------------------------------------------------------
  # StringCleaner
  # ------------------------------------------------------------------
  test 'StringCleaner removes leading/trailing punctuation and whitespace' do
    input    = "   Hello world.  "
    expected = 'Hello world'

    assert_equal expected, StringCleaner.call(input)
  end

  test 'StringCleaner removes leading commas' do
    input    = ',,,foo bar'
    expected = 'foo bar'

    assert_equal expected, StringCleaner.call(input)
  end

  test 'StringCleaner strips HTML tags and unescapes entities' do
    input    = '<strong>Hello &amp; welcome.</strong>'
    expected = 'Hello & welcome'

    assert_equal expected, StringCleaner.call(input)
  end

  test 'StringCleaner handles empty string' do
    assert_equal '', StringCleaner.call('')
  end

  test 'StringCleaner raises when given nil' do
    assert_raises(NoMethodError) { StringCleaner.call(nil) }
  end

  # ------------------------------------------------------------------
  # TextCleaner
  # ------------------------------------------------------------------
  test 'TextCleaner trims leading and trailing whitespace' do
    input    = "  hello world  "
    expected = 'hello world'

    assert_equal expected, TextCleaner.call(input)
  end

  test 'TextCleaner leaves internal whitespace untouched' do
    input    = " foo   bar "
    expected = 'foo   bar' # internal spacing should be preserved

    assert_equal expected, TextCleaner.call(input)
  end

  test 'TextCleaner converts whitespace-only string to empty string' do
    assert_equal '', TextCleaner.call('    ')
  end

  test 'TextCleaner handles empty string' do
    assert_equal '', TextCleaner.call('')
  end

  test 'TextCleaner raises when given nil' do
    assert_raises(NoMethodError) { TextCleaner.call(nil) }
  end

  # ------------------------------------------------------------------
  # BrandScrubber
  # ------------------------------------------------------------------
  test 'BrandScrubber removes "Land O Lakes" brand including the ® symbol' do
    input    = 'Land O Lakes® Butter'
    expected = ' Butter'

    assert_equal expected, BrandScrubber.call(input)
  end

  test 'BrandScrubber removes "Diamond Crystal" brand' do
    input    = 'Diamond Crystal Kosher Salt'
    expected = ' Kosher Salt'

    assert_equal expected, BrandScrubber.call(input)
  end

  test 'BrandScrubber leaves untouched string without brands' do
    input = 'Generic Sugar'

    assert_equal input, BrandScrubber.call(input)
  end

  test 'BrandScrubber handles empty string' do
    assert_equal '', BrandScrubber.call('')
  end

  test 'BrandScrubber raises when given nil' do
    assert_raises(NoMethodError) { BrandScrubber.call(nil) }
  end
end
