class CustomExamPolicy < ApplicationPolicy

  def new?
    user.student?
  end

  def show?
    user.student? && record.user.profession == user.profession
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
