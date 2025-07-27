# frozen_string_literal: true

module Admin
  class AccountRequestsController < Admin::ApplicationController
    before_action :set_account_request, only: %i[dismiss create_account]

    def index
      @show_all = ActiveModel::Type::Boolean.new.cast(params[:all])
      scope = @show_all ? AccountRequest.all : AccountRequest.pending
      @account_requests = scope.order(created_at: :desc).includes(:user)
    end

    def dismiss
      @account_request.update(dismissed: true)
      redirect_to admin_account_requests_path, notice: "Request dismissed."
    end

    def create_account
      if @account_request.user
        redirect_to admin_account_requests_path, alert: "User already exists."
      else
        User.create!(email_address: @account_request.email, password: SecureRandom.base58(12))
        redirect_to admin_account_requests_path, notice: "User created."
      end
    end

    private

    def set_account_request
      @account_request = AccountRequest.find(params[:id])
    end
  end
end
