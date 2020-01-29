class AddTriesToUserFlashcard < ActiveRecord::Migration[6.0]
  def change
    add_column :user_flashcards, :tries, :integer, default: 0
  end
end
