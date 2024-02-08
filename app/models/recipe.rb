class Recipe < ApplicationRecord
  METADATA_ATTRS = [:name, :description, :image_url]

  before_save :update_metadata

  private

  def update_metadata
    METADATA_ATTRS.each do |attribute|
      value = read_attribute(attribute)
      next if value.present?
      write_attribute(attribute, schema_extractor.send(attribute))
    end

    self.schema      = schema_extractor.raw_schema
    self.data        = schema_extractor.data.to_json
  end

  def schema_extractor
    @schema_extractor||= SchemaExtractor.new(url)
  end
end
