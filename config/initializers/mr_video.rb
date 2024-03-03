if Rails.env.development? && defined?(MrVideo)
  MrVideo.configure do |config|
    config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  end
end
