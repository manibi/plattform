# Module containing Terms
class Category < ApplicationRecord
  has_many    :articles, dependent: :destroy
  belongs_to  :topic


  def category_flashcards
    Flashcard.joins(:article).where(articles: {category: self})
  end
end
