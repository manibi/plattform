class FlashcardPolicy < ApplicationPolicy
  def show?
    record.article.category.topic.profession == user.profession || user.admin?
  end

  def new?
    user.author? || user.admin?
  end

  def create?
    new?
  end

  def update?
    user.author? && record.article.category.topic.profession == user.profession || user.admin?
  end

  def edit?
    update?
  end

  class Scope < Scope
    def resolve
      # scope.all
      # Return all articles to access the flashcards based on article
      Article.published.joins(:category)
      .where(categories: { topic: [user.profession.topics] })
    end
  end
end
