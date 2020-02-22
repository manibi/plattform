class ApplicationController < ActionController::Base
  include Pundit
  # include Accessible
  # skip_before_action :check_user, only: :destroy

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!
  # before_action :authenticate_company!
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  #! uncomment for production
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  # Redirect after login
  # def after_sign_in_path_for(resource)
  #   check_user
  # end

  # Register new user without email, use just a uniq string
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
