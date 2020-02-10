class Topic < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:name]

  belongs_to  :profession
  has_many    :categories, dependent: :destroy

  validates :name, presence: true, allow_blank: false
  validates :profession_id, presence: true

  def topic_flashcards
    Flashcard.joins(:article).where(articles: {category: [self.categories]})
  end
end
