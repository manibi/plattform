class User < ApplicationRecord
  belongs_to  :profession
  has_many    :user_articles
  has_many    :articles, through: :user_articles

  # TODO: implement recoverable
  # TODO: override the devise controller - do not allow users to update the username
  # TODO: the admin should be able to reset user passwords
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username]

  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  UPDATE_PROFILE_MESSAGE = "Please complete your profile, add an exam date!"

  validates :username, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :profession_id, presence: true

  # Remove devise email validations
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def bookmarked_articles
    Article.joins(:user_articles).where(user_articles: {
      user: self,
      bookmarked: true
    })
  end

  def read_articles
    Article.joins(:user_articles).where(user_articles: {
      user: self,
      read: true
      })
  end

  def upcoming_articles
    Article.left_outer_joins(:user_articles).where(user_articles: {
      article_id: nil
    })
  end
end
