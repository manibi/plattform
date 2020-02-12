class User < ApplicationRecord
  belongs_to  :profession
  has_many    :user_articles, dependent: :destroy
  has_many    :articles, through: :user_articles
  has_many    :user_flashcards, dependent: :destroy
  has_many    :custom_exams, dependent: :destroy
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
  validates :exam_date, presence: true, on: :update
  validate  :validate_dated_around_now, on: :update

  # Make sure exam_date isn't in the past or more than 5 years in the future
  def validate_dated_around_now
    self.errors.add(:exam_date, "is not valid") unless ((Date.today)..(5.years.from_now)).include?(self.exam_date)
  end

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
    Article.joins(:category).where(categories: {
      topic: [self.profession.topics]
    })
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
    Article.joins(:category)
            .where(categories: { topic: [user.profession.topics] }) -
    Article.joins(:user_articles)
            .where(user_articles: { user: user, read: true })
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

  # Return true if the flashcard is answered
  def answered?(flashcard)
    UserFlashcard.where(user: self, flashcard: flashcard).present?
  end

  # Return all user_flashcards for user, article
  def user_flashcards_for(article)
    UserFlashcard.where(user: self, flashcard: [article.flashcards])
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
