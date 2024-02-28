module ApplicationHelper
  EXTERNAL_ROUTES = {
    source_code:    'https://github.com/bradly/recipin',
    support:        'https://github.com/bradly/recipin/issues',
    changelog:      'https://github.com/bradly/recipin/commits/main',
  }

  EXTERNAL_ROUTES.each do |name, path|
    define_method "#{name}_path" do
      path
    end
  end

  def parse(...)
    JSON.parse(...)
  end

  def component_link
    tag.span class: 'absolute inset-x-0 -top-px bottom-0'
  end

  def icon_for(name, text: nil, gap: 3, size: 'lg', variant: 'regular', icon_class: nil, wrapper_class: '')
    wrapper_class += " flex gap-#{gap} items-center" if text.present?

    tag.span class: wrapper_class do
      icon "fa-#{variant}", name.to_s.dasherize, text, class: "fa-#{size} #{icon_class}"
    end
  end

  def url_host(url)
    URI.parse(url).host.remove /\Awww\./
  end

  def wrap_in_tag(tag, strings)
    Array.wrap(strings).map { content_tag(tag, _1) }.join.html_safe
  end

  def wrap_numerics(str, tag: 'span')
    strip_tags(str).gsub(/(\d+\/\d+|\d+\.\d+|\d+°?)/) { "<#{tag} class='numeric'>#{$1}</#{tag}>" }.html_safe
  end
end
