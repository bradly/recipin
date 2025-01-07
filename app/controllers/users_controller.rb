class UsersController < Clearance::UsersController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(allowed_params)
      redirect_to profile_path, notice: 'User saved'
    else
      render :edit, alert: 'There was a problem saving the account'
    end
  end
end
