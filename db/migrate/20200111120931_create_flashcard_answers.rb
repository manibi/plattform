class CreateFlashcardAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :flashcard_answers do |t|
      t.references :flashcard, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
