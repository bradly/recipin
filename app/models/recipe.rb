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

  normalizes :name, :description, :url, with: StringCleaner
  normalizes :name, :description, with: BrandScrubber

  def updatable_attrs
    METADATA_ATTRS.select { public_send(it).blank? }
  end

  def update_metadata
    # Guard against extractor sources returning `nil` for collection
    # associations (e.g. `instruction_sections`).
    #
    # When `assign_attributes` encounters a key whose value is `nil` for a
    # `has_many` / collection association, ActiveRecord ends up invoking the
    # association writer (`instruction_sections=` in this case) with `nil`.
    # Internally, the collection association implementation assumes it can
    # iterate over the incoming value and raises
    # `NoMethodError: undefined method 'each' for nil`.
    #
    # To avoid this entire class of issues we strip out any keys whose values
    # are `nil` *before* calling `assign_attributes`. For defensive coding we
    # also coerce an explicit `nil` for `instruction_sections` into an empty
    # array – this keeps the key present if upstream callers rely on it while
    # still giving ActiveRecord a safe value.
    raw_data = extractor.data.slice(*updatable_attrs)

    if raw_data.key?(:instruction_sections) && raw_data[:instruction_sections].nil?
      raw_data[:instruction_sections] = []
    end

    # Remove any remaining nils so we never invoke attribute writers with nil
    # unintentionally.
    data = raw_data.compact

    assign_attributes(data)
  end

  def extractor
    @extractor ||= RecipeExtractor.new(url)
  end
end
