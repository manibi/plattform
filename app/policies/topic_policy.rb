class TopicPolicy < ApplicationPolicy
  def show?
    record.profession == user.profession
  end

  class Scope < Scope
    def resolve
      if user.student?
        user.profession.topics
      end
    end
  end
end
