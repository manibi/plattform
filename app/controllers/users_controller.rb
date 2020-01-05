class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
    @user = current_user
  end

  def update
    current_user.update(user_params)
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :birth_date, :exam_date, :email)
  end

end
