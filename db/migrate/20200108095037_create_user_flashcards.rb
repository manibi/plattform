class CreateUserFlashcards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_flashcards do |t|
      t.boolean :correct
      t.references :flashcard, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
