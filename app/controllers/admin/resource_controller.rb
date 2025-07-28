module Admin
  class ResourceController < ::ResourceController
    before_action :require_admin
  end
end
