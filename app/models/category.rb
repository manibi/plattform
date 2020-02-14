# Module containing Terms
class Category < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title]

  has_many    :articles, dependent: :destroy
  belongs_to  :topic

  validates :title, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: true
  validates :topic_id, presence: true

  def category_flashcards
    Flashcard.joins(:article).where(articles: {category: self})
  end
end
