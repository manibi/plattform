class Flashcard < ApplicationRecord
  belongs_to        :article
  has_many          :user_flashcards, dependent: :destroy
  has_many          :flashcard_answers, dependent: :destroy
  has_many          :answers, through: :flashcard_answers
  has_one_attached  :image

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

  # Store flashcard answer, increment tries if answer is false
  def save_answer_for!(user, answer=false)
    user_flashcard = UserFlashcard.find_or_create_by(user: user, flashcard: self)
    tries = user_flashcard.tries
    tries += 1
    user_flashcard.update(correct: answer, tries: tries)
  end

  # Reset played flashcards for one article
  def self.reset_for!(user, article)
    UserFlashcard.where(user: user, flashcard: article.flashcards).destroy_all
  end

  # Reset all flashcards
  def self.reset_all_for!(user)
    UserFlashcard.where(user: user).destroy_all
  end
end
