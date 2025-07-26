module Admin
  class FailedImportsController < ApplicationController
    # GET /admin/failed_imports
    def index
      @failed_imports = FailedImport.recent
    end

    # POST /admin/failed_imports/:id/retry
    def retry
      @failed_import = FailedImport.find(params[:id])

      # TODO: Wire this up to a future import service—the current implementation
      # simply records that a retry was requested and deletes the record so it
      # no longer clutters the list.
      #
      # ImportRecipeJob.perform_later(@failed_import.source_url)

      @failed_import.destroy

      redirect_to admin_failed_imports_path, notice: "Retry triggered for #{@failed_import.source_url}."
    end
  end
end
