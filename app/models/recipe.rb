require "open-uri"

class Recipe < ApplicationRecord
  include FeaturedImage

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

  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy

  before_save :update_metadata

  normalizes :name, :description, with: StringCleaner
  normalizes :name, :description, with: BrandScrubber

  scope :active, -> { where.not(name: nil).with_featured_image }

  def updatable_attrs
    METADATA_ATTRS.select do
      public_send(_1).blank?
    end
  end

  def update_metadata
    updatable_attrs.each do
      public_send(:"#{_1}=", schema_extractor.public_send(_1))
    end
  end

  def schema_extractor
    @schema_extractor ||= SchemaExtractor.new(url)
  end
end
