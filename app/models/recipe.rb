class Recipe < ApplicationRecord
  METADATA_ATTRS = [
    :name,
    :description,
    :image_url,
    :prep_time,
    :cook_time,
    :total_time,
    :ingredients,
    :instructions,
    :servings,
  ]

  before_save :update_metadata

  has_many :notes, dependent: :destroy

  normalizes :name, with: -> name {
    ActionController::Base.helpers.sanitize(
      ActionController::Base.helpers.strip_tags(
        CGI.unescapeHTML(
          name.remove /\.\Z/
        )
      )
    )
  }

  normalizes :ingredients, with: -> ingredients {
    ingredients.remove 'Land O Lakes®'
  }

  def update_metadata
    METADATA_ATTRS.each do |attribute|
      next if read_attribute(attribute).present?
      write_attribute(attribute, schema_extractor.send(attribute))
    end

    self.schema = schema_extractor.raw_json
    self.data   = schema_extractor.schema.to_json
  end

  def schema_extractor
    @schema_extractor ||= SchemaExtractor.new(url)
  end

  def ingredients
    JSON.parse(
      read_attribute(:ingredients).presence || '[]'
    ).flatten.map {
      _1.downcase.remove('land o lakes®')
    }
  end

  def instructions
    Array.wrap(read_attribute(:instructions)&.split(/\d+\.\s/)).compact_blank
  end

  def tags
    [
      'Breakfast',
      'Baked',
    ]
  end
end
