class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :set_collection,   only: :index
  before_action :set_resource,     except: :index

  def index; end
  def   new; end
  def  edit; end
  def  show; end

  def create
    if @resource.save!
      redirect_to @resource, notice: save_success_message
    else
      render :new, alert: save_failed_message
    end
  end

  def update
    if @resource.update!(resource_params)
      redirect_to @resource, notice: save_success_message
    else
      render :edit, alert: save_failed_message
    end
  end

  def destroy
    @resource.destroy!
    redirect_to [collection_name.to_sym]
  end

  private

  def resource_scope
    resource_name.camelize.constantize
  end

  def resource_name
    controller_name.singularize
  end

  def set_collection
    instance_variable_set("@#{collection_name}", resource_scope.all)
  end

  def set_resource
    @resource ||= begin
      @resource = case action_name
                  when 'new'
                    resource_scope.new
                  when 'create'
                    resource_scope.new(resource_params)
                  else
                    resource_scope.find(params[:id])
                  end

      instance_variable_set("@#{resource_name}", @resource)

      @resource
    end
  end

  def collection_name
    resource_name.pluralize
  end

  def resource_params
    params.require(resource_name).permit(*permitted_params)
  end

  def permitted_params
    self.class.instance_variable_get(:"@permitted_params")
  end

  def save_success_message
    "#{resource_name} saved"
  end

  def save_failed_message
    "There was a problem saving this #{resource_name}"
  end
end
