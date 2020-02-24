class UserPolicy < ApplicationPolicy
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

  def search?
    current_user?
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
