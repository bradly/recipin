module CoreExt
end
class String
  def to_ingredients
    IngredientParser.new(self).parse
  end
end
