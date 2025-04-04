class ResourceController < ApplicationController
  before_action :set_collection,   only: :index
  before_action :set_resource,     except: :index

  attr_reader :resource, :parent

  def create
    if create_behaviour
      redirect_to create_redirect_path, notice: save_success_message
    else
      flash.now[:alert] = save_failed_message
      render :new
    end
  end

  def create_redirect_path
    if parent
      [parent, resource]
    else
      resource
    end
  end

  def update
    if update_behaviour
      redirect_to resource, notice: save_success_message
    else
      flash.now[:alert] = save_failed_message
      render :edit
    end
  end

  def destroy
    destroy_behaviour!
    redirect_to [collection_name.to_sym], notice: "#{resource_name.titleize} was successfully deleted."
  end

  private

  def self.login_required(...)
    before_action(:require_login, ...)
  end

  def resource_scope
    resource_name.camelize.constantize
  end

  def resource_name
    controller_name.singularize
  end

  def set_collection
    instance_variable_set("@#{collection_name}", collection_scope)
  end

  def collection_scope
    resource_scope.all
  end

  def set_resource
    @resource ||= begin
      @resource = case action_name
      when "new"
        resource_scope.new
      when "create"
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
    params.require(resource_name).permit(allowed_parameters)
  end

  def save_success_message
    "#{resource_name.titleize} saved"
  end

  def save_failed_message
    "There was a problem saving this #{resource_name}"
  end

  def create_behaviour
    resource.save
  end

  def create_behaviour!
    resource.save!
  end

  def update_behaviour
    resource.update(resource_params)
  end

  def update_behaviour!
    resource.update!(resource_params)
  end

  def destroy_behaviour
    resource.destroy
  end

  def destroy_behaviour!
    resource.destroy!
  end
end
