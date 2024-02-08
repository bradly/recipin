class Recipe < ApplicationRecord
  before_save :update_metadata

  private

  def update_metadata
    self.name        ||= schema_extractor.name
    self.description ||= schema_extractor.description
    self.image_url   ||= schema_extractor.image_url
    self.schema      ||= schema_extractor.raw_schema
  end

  def schema_extractor
    @schema_extractor||= SchemaExtractor.new(url)
  end
end
