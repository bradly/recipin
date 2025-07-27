# frozen_string_literal: true

class AccountRequestsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @account_request = AccountRequest.new(email: params[:email])
  end

  def create
    @account_request = AccountRequest.new(account_request_params)

    if @account_request.save
      redirect_to root_path, notice: "Thanks! We'll be in touch soon."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def account_request_params
    params.require(:account_request).permit(:email, :note)
  end
end
