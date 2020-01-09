class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create_user_flashcards_for!(user, article)
    UserFlashcard.create_all_user_flashcards_for(user, article) #if user.answered_flashcards_for(article).count != article.flashcards.count
  end

  # def get_flashcards_for(user, article)
  #   UserFlashcard.create_all_user_flashcards_for(user, article) if user.answered_flashcards_for(article).count != article.flashcards.count
  # end

  protected

  # Redirect after login
  def after_sign_in_path_for(resource)
    resource.exam_date.nil? ? welcome_path : dashboard_path
  end

  # Register new user without email, use just a uniq string
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
