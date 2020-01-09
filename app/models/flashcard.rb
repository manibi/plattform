class Flashcard < ApplicationRecord
  belongs_to :article
  has_many   :answers
  has_many   :user_flashcards

  validates :content, presence: true, allow_blank: false
  validates :article_id, presence: true

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
