class Answer < ApplicationRecord
  belongs_to :flashcard

  validates :flashcard_id, presence: true
  validates :content, presence: true, allow_blank: false
end
