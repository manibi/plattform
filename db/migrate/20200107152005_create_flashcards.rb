class CreateFlashcards < ActiveRecord::Migration[6.0]
  def change
    create_table :flashcards do |t|
      t.text       :content
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
