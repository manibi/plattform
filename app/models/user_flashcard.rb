class UserFlashcard < ApplicationRecord
  belongs_to :flashcard
  belongs_to :user

  validates :flashcard_id, presence: true
  validates :user_id, presence: true


  # Create user_flashcards with false answers for all article flashcards
  def self.create_all_user_flashcards_for(user, article)
    article.flashcards.each do |flashcard|
      flashcard.create_false_answer_for!(user)
    end
  end
end
