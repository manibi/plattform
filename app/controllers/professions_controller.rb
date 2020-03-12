class ProfessionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @profession = Profession.find(params[:id])
    authorize @profession
  end

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

  def update
    @profession = Profession.find(params[:id])
    authorize @profession

    if @profession.update(profession_params)
      redirect_to admin_dashboard_path, notice: "Profession updated!"
    else
      render :edit
    end
  end

  def destroy
    @profession = Profession.find(params[:id])
    authorize @profession
    @profession.destroy
    redirect_back(fallback_location: admin_dashboard_path)
  end

  private

  def profession_params
    params.require(:profession).permit(:name)
  end
end
