class CategoryPolicy < ApplicationPolicy

  def show?
    record.topic.profession == user.profession || user.admin?
  end

  def new?
    user.author? || user.admin?
  end

  def create?
    new?
  end

  def edit?
    user.author? || user.admin?
  end

  def update?
    edit?
  end

 class Scope < Scope
    def resolve
      scope.all
    end
  end
end
