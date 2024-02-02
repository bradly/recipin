module ApplicationHelper
  def component_link
    tag.span class: 'absolute inset-x-0 -top-px bottom-0'
  end

  def icon_for(name, text: nil, size: 'lg', variant: 'regular')
    tag.span class: 'flex gap-2 items-center' do
      icon "fa-#{variant}", name.to_s.dasherize, text, class: "fa-#{size}"
    end
  end
end
