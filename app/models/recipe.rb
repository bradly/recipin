class Recipe < ApplicationRecord
  METADATA_ATTRS = [:name, :description, :image_url]
  before_save :update_metadata

  normalizes :name, with: -> name {
    ActionController::Base.helpers.sanitize(
      ActionController::Base.helpers.strip_tags(
        CGI.unescapeHTML(
          name.remove /\.\Z/
        )
      )
    )
  }

  private

  def update_metadata
    METADATA_ATTRS.each do |attribute|
      next if read_attribute(attribute).present?
      write_attribute(attribute, schema_extractor.send(attribute))
    end

    self.schema = schema_extractor.raw_schema
    self.data   = schema_extractor.data.to_json
  end

  def schema_extractor
    @schema_extractor||= SchemaExtractor.new(url)
  end
end
