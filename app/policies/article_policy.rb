class ArticlePolicy < ApplicationPolicy
  def show?
    is_profession_student? || user.author?
  end

  class Scope < Scope
    def resolve
      if user.student?
        scope.joins(:topic)
             .where(topic_id: user.profession.topics)
             .left_outer_joins(:user_articles)
             .where(user_articles: { article_id: nil })
      elsif user.author?
        scope.all
      end
    end
  end

  private

  def is_profession_student?
    user.student? && user.profession == record.topic.profession
  end
end
