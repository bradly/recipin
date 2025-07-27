require "open-uri"

class Recipe < ApplicationRecord
  include FeaturedImage

  METADATA_ATTRS = [
    :name,
    :description,
    :servings,
    :image_url,
    :prep_time,
    :cook_time,
    :total_time,
    :ingredients,
    :instruction_sections,
  ]

  has_many :ingredients, dependent: :destroy
  has_many :instruction_sections, dependent: :destroy

  accepts_nested_attributes_for :ingredients
  accepts_nested_attributes_for :instruction_sections

  before_save :update_metadata

  normalizes :name, :description, with: StringCleaner
  normalizes :name, :description, with: BrandScrubber

  def updatable_attrs
    METADATA_ATTRS.select { public_send(it).blank? }
  end

  def update_metadata
    data = extractor.data.slice(*updatable_attrs)
    assign_attributes(data)
  rescue => e
    FailedImport.create!(source_url: url, error_message: e.message)
    raise e
  end

  def extractor
    @extractor ||= RecipeExtractor.new(url)
  end
end
