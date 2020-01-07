class Flashcard < ApplicationRecord
  belongs_to :article
  has_many   :answers

  validates :content, presence: true, allow_blank: false
  validates :article_id, presence: true
end
