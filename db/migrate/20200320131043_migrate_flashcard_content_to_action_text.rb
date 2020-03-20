class MigrateFlashcardContentToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :flashcards, :content, :content_old
    Flashcard.all.each do |flashcard|
      flashcard.update_attribute(:content, simple_format(flashcard.content_old))
    end
    remove_column :flashcards, :content_old
  end
end
