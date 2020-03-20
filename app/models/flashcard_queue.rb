class FlashcardQueue < ApplicationRecord
  belongs_to :flashcard
  belongs_to :article
  belongs_to :user
end
