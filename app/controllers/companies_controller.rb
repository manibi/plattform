class CompaniesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_company, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if current_company.update(company_params)
      redirect_to company_profile_path
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :phone_number, :email, :contact_person_name)
  end

  def set_company
    @company = current_company
    authorize @company, :show?
  end
end
