class SmsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_authentication

  def receive
    num_media = permitted[:NumMedia].to_i

    if num_media.zero?
      message = "No image found in your message."
    else
      media_urls = num_media.times.map { "MediaUrl#{_1}" }
      message = "Recipe image saved."
    end

    render xml: "<Response><Message>#{message}</Message></Response>"
  end

  private

  def permitted
     @permitted ||= params.permit(:From, :MediaUrl0, :NumMedia)
  end
end
