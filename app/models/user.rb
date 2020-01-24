class User < ApplicationRecord
  belongs_to  :profession
  has_many    :user_articles
  has_many    :articles, through: :user_articles
  has_many    :user_flashcards

  enum role: [:student, :author, :company, :admin]
  after_initialize :set_default_role, if: :new_record?

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

  # Set default role to student
  def set_default_role
    self.role ||= :student
  end

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

  def all_articles
    Article.joins(:topic).where(topic_id: self.profession.topics)
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

  # Return all answered flashcards
  def answered_flashcards
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self
    })
  end

  # Return answered flashcards for one article
  def answered_flashcards_for(article)
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self,
      flashcard: article.flashcards
    })
  end

    # Return tru if the flashcard is answered
    def answered?(flashcard)
      UserFlashcard.where(user: self, flashcard: flashcard).present?
    end

  # Return all right answered flashcards
  def right_answered_flashcards
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self,
      correct: true
    })
  end

  # Return all right answered flashcards for one article
  def correct_answered_flashcards_for(article)
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self,
      flashcard: article.flashcards,
      correct: true
    })
  end

  # Return all wrong answered flashcards
  def wrong_answered_flashcards
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self,
      correct: false
    })
  end

  # Return wrong answered flashcards for one article
  def wrong_answered_flashcards_for(article)
    Flashcard.joins(:user_flashcards).where(user_flashcards: {
      user: self,
      flashcard: article.flashcards,
      correct: false
    })
  end
end
