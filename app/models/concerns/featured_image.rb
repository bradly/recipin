module FeaturedImage
  extend ActiveSupport::Concern

  included do
    has_one_attached :featured_image do |attachable|
      [100, 500, 1000].each do |size|
        [:limit, :fit].each do |type|
          attachable.variant :"#{type}_#{size}", "resize_to_#{type}": [size, size], preprocessed: true
        end
      end
    end

    scope :with_featured_image, -> do
      left_joins(:featured_image_attachment).where.not(active_storage_attachments: { id: nil })
    end

    after_save :set_featured_image, if: :saved_change_to_image_url?
  end

  def set_featured_image
    return featured_image.purge if image_url.blank?

    uri = URI.parse(image_url)
    downloaded_file = uri.open(read_timeout: 10, ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER)

    featured_image.attach(
      io: downloaded_file,
      filename: File.basename(uri.path),
      content_type: downloaded_file.content_type
    )
  rescue OpenURI::HTTPError, Net::OpenTimeout, SocketError => e
    errors.add(:base, "Failed to download image: #{e.message}")
    throw :abort
  end
end
