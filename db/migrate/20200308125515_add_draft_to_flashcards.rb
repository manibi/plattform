class AddDraftToFlashcards < ActiveRecord::Migration[6.0]
  def change
    add_column :flashcards, :draft, :boolean, default: true
    add_column :flashcards, :published_at, :datetime
  end
end
