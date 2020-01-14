class Flashcard < ApplicationRecord
  belongs_to :article
  has_many   :user_flashcards
  has_many   :flashcard_answers
  has_many   :answers, through: :flashcard_answers

  serialize :correct_answers, Array

  validates :content, presence: true, allow_blank: false
  validates :article_id, presence: true
  validates :flashcard_type, presence: true, inclusion: {
    in: ["multiple_choice", "correct_order"]
  }

  # Store flashcard answer
  def save_answer_for!(user, answer=false)
    UserFlashcard.find_or_create_by(user: user, flashcard: self).update(correct: answer)
  end

  # Create a false flashcard answer
  def create_false_answer_for!(user)
    UserFlashcard.find_or_create_by(user: user, flashcard: self).update(correct: false)
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
