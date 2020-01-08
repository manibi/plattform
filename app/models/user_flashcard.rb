class UserFlashcard < ApplicationRecord
  belongs_to :flashcard
  belongs_to :user

  validates :flashcard_id, presence: true
  validates :user_id, presence: true
end
