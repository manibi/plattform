class Article < ApplicationRecord
  belongs_to  :topic
  has_many    :chapters, dependent: :destroy
  has_many    :user_articles
  has_many    :users, through: :user_articles

  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :topic_id, presence: true

  def read_for?(user)
    UserArticle.where(user: user, article: self, read: true).present?
  end

  def read_for!(user)
    UserArticle.find_or_create_by(user: user, article: self).update(read: true)
  end

  def unread_for!(user)
    UserArticle.where(user: user, article: self).update(read: false)
  end

  def bookmarked_for?(user)
    UserArticle.where(user: user, article: self, bookmarked: true).present?
  end

  def bookmark_for!(user)
    UserArticle.find_or_create_by(user: user, article: self).update(bookmarked: true)
  end

  def unbookmark_for!(user)
    UserArticle.where(user: user, article: self).update(bookmarked: false)
  end
end
