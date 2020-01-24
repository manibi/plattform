class FlashcardPolicy < ApplicationPolicy
  def show?
    record.article.topic.profession == user.profession
  end

  def new?
    user.author?
  end

  def create?
    new?
  end

  def update?
    user.author?
  end

  def edit?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
