class CategoryPolicy < ApplicationPolicy

  def show?
    record.topic.profession == user.profession || user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin?
  end

 class Scope < Scope
    def resolve
      scope.all
    end
  end
end
