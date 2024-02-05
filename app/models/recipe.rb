class Recipe < ApplicationRecord
  before_save :update_metadata

  private

  def update_metadata
    self.name        = schema.name
    self.description = schema.description
    self.image_url   = schema.image_url
  end

  def schema
    @schema ||= SchemaExtractor.new(url)
  end
end
