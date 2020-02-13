class CategoryPolicy < ApplicationPolicy

  def show?
    record.topic.profession == user.profession
  end

  def new?
    user.author?
  end

  def create?
    new?
  end

  def edit?
    user.author?
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
