# frozen_string_literal: true

# Rake tasks for working with VCR cassettes used by the recipe parsing tests.

namespace :parsing do
  desc <<~DESC
    Record a VCR cassette for the given recipe URL.

    Examples:
      # Generate a cassette using an automatic, URL-based filename
      bin/rails parsing:record_vcr[https://example.com/recipe]

      # Specify a custom cassette name (without file extension)
      bin/rails parsing:record_vcr[https://example.com/recipe,my_custom_name]
  DESC
  task :record_vcr, %i[url cassette_name] => :environment do |_t, args|
    url = args[:url]

    unless url.present?
      warn 'ERROR: URL argument is required. Example: bin/rails parsing:record_vcr[https://example.com/recipe]'
      exit 1
    end

    cassette_name = args[:cassette_name].presence || url.parameterize.presence || 'recipe'

    cassette_dir = Rails.root.join('test', 'fixtures', 'vcr_cassettes')
    FileUtils.mkdir_p(cassette_dir)

    require 'vcr'
    require 'webmock'

    VCR.configure do |config|
      config.cassette_library_dir = cassette_dir
      config.hook_into :webmock
      config.ignore_localhost = true
      config.default_cassette_options = { record: :all }
    end

    puts "Recording VCR cassette '#{cassette_name}.yml' for #{url}..."

    VCR.use_cassette(cassette_name) do
      extractor = RecipeExtractor.new(url)
      begin
        extractor.data
        puts 'OK: fetch complete.'
      rescue StandardError => e
        warn "ERROR: Failed to fetch recipe - #{e.class}: #{e.message}"
        raise
      end
    end

    puts "Cassette saved to #{cassette_dir.join(cassette_name + '.yml')}"
  end
end
