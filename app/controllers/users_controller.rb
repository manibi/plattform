class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :birth_date, :exam_date, :email, :role)
  end

  def set_user
    @user = current_user
    authorize @user, :show?
  end
end
