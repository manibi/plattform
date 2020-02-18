class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
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
  def after_sign_in_path_for(resource)
    if current_user.student?
      resource.exam_date.nil? ? welcome_path : dashboard_path
    elsif current_user.author?
      resource.email.nil? ? welcome_path : dashboard_path
    end
  end

  # Register new user without email, use just a uniq string
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
