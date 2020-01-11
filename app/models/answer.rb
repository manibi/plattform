class Answer < ApplicationRecord
  has_many :flashcard_answers
  has_many :flashcards, through: :flashcard_answers

  validates :content, presence: true, allow_blank: false
end
