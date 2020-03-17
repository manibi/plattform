class Flashcard < ApplicationRecord
  belongs_to        :article
  has_many          :user_flashcards, dependent: :destroy
  has_many          :flashcard_answers, dependent: :destroy
  has_many          :custom_exam_answers
  has_many          :answers, through: :flashcard_answers
  has_one_attached  :image

  before_save :ensure_published_at, :unless => :draft
  accepts_nested_attributes_for :answers,
                                allow_destroy: true,
                                reject_if: proc { |att| att['content'].blank? }

  serialize :correct_answers, Array

  FLASHCARD_TYPES = ["multiple_choice", "correct_order", "match_answers", "soll_ist", "table_quiz"]

  validates :content, presence: true, allow_blank: false
  validates :article_id, presence: true
  validates :flashcard_type, presence: true, inclusion: {
    in: FLASHCARD_TYPES
  }
  validates :image, content_type: {
                      in: %w[image/jpeg image/gif image/png],
                      message: "must be a valid image format"
                    },
                    size: {
                      less_than: 5.megabytes,
                      message:   "should be less than 5MB"
                    }

  # Scopes
  scope :draft,     -> { where(draft: true) }
  scope :published, -> { where(draft: false) }

  # Store flashcard answer, increment tries if answer is false
  def save_answer_for!(user, answer=false)
    user_flashcard = UserFlashcard.find_or_create_by(user: user, flashcard: self)
    tries = user_flashcard.tries
    tries += 1
    user_flashcard.update(correct: answer, tries: tries)
  end

  # Store exam flashcard answer
  def save_exam_answer_for!(exam, question_answered, user_answers=[], answer=false)
    custom_exam_answer = CustomExamAnswer.find_or_create_by(custom_exam: exam, flashcard: self)

    custom_exam_answer.update(answered: question_answered, correct: answer, answered_correct_in_exam: answer, user_answers: user_answers)
  end

  # Reset played flashcards for one article
  def self.reset_for!(user, article)
    UserFlashcard.where(user: user, flashcard: article.flashcards).destroy_all
  end

  # Reset all flashcards
  def self.reset_all_for!(user)
    UserFlashcard.where(user: user).destroy_all
  end

  def bookmarked_for?(exam)
    CustomExamAnswer.where(custom_exam: exam, flashcard: self, bookmarked: true).present?
  end

  def bookmark_for!(exam)
    CustomExamAnswer.find_or_create_by(custom_exam: exam, flashcard: self).update(bookmarked: true)
  end

  def unbookmark_for!(exam)
    CustomExamAnswer.where(custom_exam: exam, flashcard: self).update(bookmarked: false)
  end

  def authored_by?(user)
    UserFlashcard.where(user: user, flashcard: self, author: true).present?
  end

  def sign_flashcard!(user)
    UserFlashcard.find_or_create_by(user: user, flashcard: self).update(author: true)
  end

  def main_author
    User.joins(:user_flashcards).find_by(user_flashcards: { author: true,
                                                      flashcard: self })
  end

  def edited_by?(user)
    UserFlashcard.where(user: user, flashcard: self, editor: true).present?
  end

  def sign_edit_flashcard!(user)
    UserFlashcard.find_or_create_by(user: user, flashcard: self).update(editor: true)
  end

  def editors
    User.joins(:user_flashcards).where(user_flashcards: { editor: true,
                                                      flashcard: self })
  end

  # In exam return an array of user picked answer ids
  def user_answers_for(exam)
    exam_answer = self.custom_exam_answers.find_by(custom_exam: exam)
    exam_answer.user_answers if exam_answer
  end

  def publish!
    self.draft = false
    self.save
  end

  def unpublish!
    self.update(draft: true, published_at: nil)
  end

  protected

  def ensure_published_at
    self.published_at ||= Time.zone.now
  end
end
