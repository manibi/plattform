class ArticlePolicy < ApplicationPolicy
  def show?
    has_profession_student? || has_profession_author?
  end

  class Scope < Scope
    def resolve
      if user.student?
        scope.joins(:category)
             .where(categories: { topic: [user.profession.topics] }) -
        scope.joins(:user_articles)
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
end
