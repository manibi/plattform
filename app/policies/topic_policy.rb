class TopicPolicy < ApplicationPolicy
  def show?
    record.profession == user.profession
  end

  def new?
    user.author?
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

  class Scope < Scope
    def resolve
      if user.student?
        user.profession.topics
      end
    end
  end
end
