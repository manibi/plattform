class UserCredentialsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize current_user, :create
    @user_credentials = UserCredential.create(user_credentials_params)
  end

  private

  def user_credentials_params
    params.permit(:username, :password, :company, :profession, :user, :role)
  end
end
