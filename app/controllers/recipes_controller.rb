class RecipesController < ResourceController
  def require_login
    true
  end

  def allowed_parameters
    [:name, :url, :description]
  end

  helper_method def recipe
    resource
  end

  def create_behaviour
    super
  rescue => e
    FailedImport.create!(
      source_url: resource_params[:url],
      error_message: e.message,
    )
    raise e
  end
end
