module ApplicationHelper
  def body_classes
    [
      controller_name,
      "#{action_name}-action",
      "#{controller_name}-#{action_name}",
    ].join(" ")
  end

  def wrap_numerics(str, tag: "span")
    strip_tags(str).gsub(/(\d+\/\d+|\d+\.\d+|\d+°?)/) { "<#{tag} class='numeric'>#{$1}</#{tag}>" }.html_safe
  end

  def recipe_timings(recipe)
    %w[total prep cook].each_with_object({}) do |key, hash|
      hash["#{key.titlecase}:"] = recipe.public_send(:"#{key}_time").presence
    end.compact
  end
end
