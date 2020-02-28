class CompanyCredentialsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize current_user, :create
    @company_credentials = CompanyCredential.create(company_credentials_params)
  end

  private

  def company_credentials_params
    params.permit(:username, :password, :user)
  end
end
