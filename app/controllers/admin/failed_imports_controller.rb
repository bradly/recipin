class Admin::FailedImportsController < Admin::BaseController
  before_action :set_failed_import, only: [:retry]

  def index
    @failed_imports = FailedImport.all.order(created_at: :desc)
  end

  def retry
    recipe_data = RecipeExtractor.new(@failed_import.url).data
    if recipe_data
      Recipe.create!(recipe_data)
      @failed_import.destroy
      redirect_to admin_failed_imports_path, notice: "Successfully re-imported recipe."
    else
      @failed_import.update(error_message: "Retry failed.")
      redirect_to admin_failed_imports_path, alert: "Failed to re-import recipe."
    end
  end

  private

  def set_failed_import
    @failed_import = FailedImport.find(params[:id])
  end
end
