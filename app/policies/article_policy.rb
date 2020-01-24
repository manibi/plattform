class ArticlePolicy < ApplicationPolicy
  def show?
    has_profession_student? || has_profession_author?
  end

  class Scope < Scope
    def resolve
      if user.student?
        scope.joins(:topic)
             .where(topic_id: user.profession.topics)
             .left_outer_joins(:user_articles)
             .where(user_articles: { article_id: nil })
      elsif user.author?
        scope.joins(:topic)
             .where(topic_id: user.profession.topics)
      end
    end
  end

  def has_profession_student?
    user.student? && user.profession == record.topic.profession
  end

  def has_profession_author?
    user.author? && user.profession == record.topic.profession
  end
end
