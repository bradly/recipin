class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
end
