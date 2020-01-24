class UserPolicy < ApplicationPolicy
  def show?
    is_user? || user.admin?
  end

  def author_dashboard?
    is_user? && user.author?
  end

  def dashboard?
    is_user? && user.student?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      end
    end
  end

  private

  def is_user?
    record == user
  end
end
