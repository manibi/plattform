class UserPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def show?
    current_user? || user.admin?
  end

  def author_dashboard?
    current_user? && user.author?
  end

  def dashboard?
    current_user? && user.student?
  end

  def admin_dashboard?
    user.admin?
  end

  def admin_professions?
    user.admin?
  end

  def admin_topics?
    user.admin?
  end

  def admin_categories?
    user.admin?
  end

  def search?
    current_user?
  end

  def send_temp_user_credentials?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      end
    end
  end

  private

  def current_user?
    record == user
  end
end
