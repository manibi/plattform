class CategoryPolicy < ApplicationPolicy

  def show?
    record.topic.profession == user.profession
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
