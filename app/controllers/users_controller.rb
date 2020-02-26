class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :new_author, :generate_author]

  def new
    @user = User.new
    authorize current_user
  end

  def create
    @user = User.new
    @user_credentials = UserCredential.new
    authorize current_user

    company = Company.find_by(name: "Mozubi")
    profession = Profession.find_by(name: "Controlling")
    new_user_params = user_params
    new_user_params[:profession] = profession
    new_user_params[:company] = company
    new_admin = generate_admin(new_user_params)
    @user = User.new(new_admin)

    # Save credentials for printing
    new_admin_credentials = new_admin.except(:first_name, :last_name, :email)
    @user_credentials = UserCredential.new(new_admin_credentials.merge({ user: current_user }))

    if @user.save
      @user_credentials.save
      flash[:notice] = "Admin created."
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  def new_author
    authorize current_user, :create?
    @professions = Profession.all
  end

  def generate_author
    authorize current_user, :create?
    company = Company.find_by(name: "Mozubi")
    profession = Profession.find(author_params[:profession_id])
    new_authors_params = generate_authors(company,
      profession,
      author_params[:authors_number].to_i)

    if User.create(new_authors_params)
      flash[:notice] = "#{new_authors_params.size} #{"author".pluralize(new_authors_params)} created."

    # Save credentials for printing
    save_author_credentials(new_authors_params, current_user)

    redirect_to admin_dashboard_path
    end
  end

  def new_student
    authorize current_user, :create?
    @companies = Company.all
    @professions = Profession.all
  end

  def generate_student
    authorize current_user, :create?
    company = Company.find(student_params[:company_id])
    profession = Profession.find(student_params[:profession_id])
    new_students_params = generate_students(company,
      profession,
      student_params[:students_number].to_i)

    if User.create(new_students_params)
      flash[:notice] = "#{new_students_params.size} #{"student".pluralize(new_students_params)} created."

    # Save credentials for printing
    save_students_credentials(new_students_params, current_user)

    redirect_to admin_dashboard_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :birth_date, :exam_date, :email, :role)
  end

  def author_params
    params.permit(:profession_id, :authors_number)
  end

  def student_params
    params.permit(:company_id, :profession_id, :students_number)
  end

  def set_user
    @user = current_user
    authorize @user, :show?
  end
end
