class ProfessionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @profession = Profession.new
    authorize @profession
  end

  def create
    @profession = Profession.new(profession_params)
    authorize @profession

    if @profession.save
      flash[:notice] = "Profession added."
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def edit
    @profession = Profession.find(params[:id])
    authorize @profession
  end

  private

  def profession_params
    params.require(:profession).permit(:name)
  end
end
