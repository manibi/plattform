class ProfessionPolicy < ApplicationPolicy
  def new?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
   new?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
