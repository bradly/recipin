module Admin
  class FailedImportsController < ApplicationController
    def index
      @failed_imports = FailedImport.recent
    end

    def retry
      failed_import = FailedImport.find(params[:id])
      # TODO: Implement retry
      redirect_to admin_failed_imports_path, notice: "Retry triggered for #{failed_import.source_url}."
    end
  end
end
