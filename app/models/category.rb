# Module containing Terms
class Category < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title]

  has_many    :articles, dependent: :destroy
  belongs_to  :topic

  def category_flashcards
    Flashcard.joins(:article).where(articles: {category: self})
  end
end
