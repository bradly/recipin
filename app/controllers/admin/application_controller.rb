module Admin
  class ApplicationController < ::ApplicationController
    before_action :require_admin
  end
end
