class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?


  def create_user_flashcards_for!(user, article)
    UserFlashcard.create_all_user_flashcards_for(user, article)
  end

  protected

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  # Redirect after login
  def after_sign_in_path_for(resource)
    resource.exam_date.nil? ? welcome_path : dashboard_path
  end

  # Register new user without email, use just a uniq string
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
