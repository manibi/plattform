class ArticlePolicy < ApplicationPolicy
  def show?
    (has_profession_student? && article_published?) || has_profession_author?
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

  def read?
    show?
  end

  def unread?
    show?
  end

  def bookmark?
    show?
  end

  def unbookmark?
    show?
  end

  def flashcards?
    edit?
  end

  def publish?
    edit?
  end

  def unpublish?
    edit?
  end

  class Scope < Scope
    def resolve
      if user.student?
        scope.published.joins(:category)
             .where(categories: { topic: [user.profession.topics] }) -
        scope.published.joins(:user_articles)
              .where(user_articles: { user: user, read: true })
      elsif user.author?
        scope.joins(:category)
             .where(categories: { topic: [user.profession.topics] })
      end
    end
  end

  def has_profession_student?
    user.student? && user.profession == record.category.topic.profession
  end

  def has_profession_author?
    user.author? && user.profession == record.category.topic.profession
  end

  def article_published?
    record.published_at
  end
end
