# Term
class Article < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title]

  belongs_to        :category
  has_many          :chapters, dependent: :destroy
  has_many          :user_articles
  has_many          :users, through: :user_articles
  has_many          :flashcards, dependent: :destroy
  has_one_attached  :image

  accepts_nested_attributes_for :chapters,
                                allow_destroy: true,
                                reject_if: proc { |att| att['title'].blank? || att['content'].blank? }

  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :category_id, presence: true
  validates :image, content_type: {
                      in: %w[image/jpeg image/gif image/png],
                      message: "must be a valid image format"
                    },
                    size: {
                      less_than: 5.megabytes,
                      message:   "should be less than 5MB"
                    }

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

  def authored_by?(user)
    UserArticle.where(user: user, article: self, author: true).present?
  end

  def sign_article!(user)
    UserArticle.find_or_create_by(user: user, article: self).update(author: true)
  end

  def main_author
    User.joins(:user_articles).find_by(user_articles: { author: true,
                                                      article: self })
  end

  def edited_by?(user)
    UserArticle.where(user: user, article: self, editor: true).present?
  end

  def sign_edit_article!(user)
    UserArticle.find_or_create_by(user: user, article: self).update(editor: true)
  end

  def editors
    User.joins(:user_articles).where(user_articles: { editor: true,
                                                      article: self })
  end
end
