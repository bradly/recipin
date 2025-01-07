module ApplicationHelper
  def body_classes
    [
      controller_name,
      "#{controller_name}-#{action_name}",
    ].join(" ")
  end

  def wrap_numerics(str, tag: "span")
    strip_tags(str).gsub(/(\d+\/\d+|\d+\.\d+|\d+°?)/) { "<#{tag} class='numeric'>#{$1}</#{tag}>" }.html_safe
  end
end
