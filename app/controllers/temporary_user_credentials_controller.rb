class TemporaryUserCredentialsController < ApplicationController
  include UsersHelper

  before_action :authenticate_user!, except: [:new, :create]

  def new
    @temporary_user = TemporaryUserCredential.new
    authorize @temporary_user
    @professions = Profession.where(name: [
      "Büromanagement",
      "Industriemechanik",
      "Industriekaufleute",
      "Groß-und Außerhandel"
    ])
  end

  def create
    @temporary_user = TemporaryUserCredential.new
    authorize @temporary_user
    company = Company.find_by(name: "Mozubi")
    profession = Profession.find(temporary_user_params[:profession_id])
    new_temporary_user_params = generate_students(company, profession, 1).first

    if @new_temporary_user = User.create(new_temporary_user_params)
      TemporaryUserCredential.create!(temporary_user_params.merge(new_temporary_user_params))
      @new_temporary_user.update(temporary_user_params.except(:company_name, :school_name, :feedback))

      redirect_to temp_user_success_path
    else
      render :new
    end
  end

  def send_temp_user_credentials
    authorize current_user
    @user = TemporaryUserCredential.find(params[:temporary_user_credential_id])
    UserMailer.welcome(@user).deliver_now
    @user.update(sent_email: true)
    redirect_to admin_dashboard_path
  end

  private

  def temporary_user_params
    params.require(:temporary_user_credential).permit(TemporaryUserCredential.attribute_names.map(&:to_sym))
  end
end
