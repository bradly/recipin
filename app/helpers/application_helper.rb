module ApplicationHelper
  def icon_for(name, text: nil, gap: 3, size: 'lg', variant: 'regular', icon_class: nil, wrapper_class: '')
    wrapper_class += " flex gap-#{gap} items-center" if text.present?

    tag.span class: wrapper_class do
      icon "fa-#{variant}", name.to_s.dasherize, text, class: "fa-#{size} #{icon_class}"
    end
  end

  def icon(style, name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class
    html_options['aria-hidden'] ||= true

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end
end
