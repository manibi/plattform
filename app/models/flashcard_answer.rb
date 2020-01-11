class FlashcardAnswer < ApplicationRecord
  belongs_to :flashcard
  belongs_to :answer

  validates :flashcard_id, presence: true
  validates  :answer_id, presence: true
end
