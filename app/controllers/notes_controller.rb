class NotesController < ResourceController
  login_required
  feed_enabled

  allowed_parameters :body

  def resource_scope
    @parent ||= Recipe.find(params[:recipe_id])
    @resourece_scope ||= @parent.notes
  end

  def create_redirect_path
    parent
  end
end
