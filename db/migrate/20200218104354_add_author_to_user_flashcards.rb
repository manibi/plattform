class AddAuthorToUserFlashcards < ActiveRecord::Migration[6.0]
  def change
    add_column :user_flashcards, :author, :boolean, default: false
    add_column :user_flashcards, :editor, :boolean, default: false
  end
end
