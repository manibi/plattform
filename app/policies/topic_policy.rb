class TopicPolicy < ApplicationPolicy
  def show?
    record.profession == user.profession || user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.student?
        user.profession.topics
      end
    end
  end
end
