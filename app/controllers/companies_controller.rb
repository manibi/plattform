class CompaniesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_authorize_company
  include ApplicationHelper

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

  def user_details
    @user = User.find(params[:user_id])
    @articles_percentage = calculate_percentage(@user.read_articles.count,
      @user.all_articles.count)
    @flashcards_percentage = calculate_percentage(@user.answered_flashcards.count, @user.profession_flashcards.count)
    @exams = @user.answered_flashcards.count
    min_exams_todo = 10
    @exams_percentage = calculate_percentage(@exams, min_exams_todo)
    @overall_progress = ([
      @articles_percentage,
      @flashcards_percentage,
      @exams_percentage].sum / 3)
  end

  def company_dashboard
    # @users = current_company.users
    company_professions = @company.professions.uniq

    # Return collections of users based on professions
    @professions_users = company_professions.map.with_index do |profession, i|
      instance_variable_set("@profession_#{i += 1}", profession.students)
    end
    # raise
  end

  # Set pundit user to a company instance
  def pundit_user
    current_company
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :phone_number, :email, :contact_person_name)
  end

  def set_authorize_company
    @company = current_company
    authorize @company
  end
end
