class CreateFlashcardQueues < ActiveRecord::Migration[6.0]
  def change
    create_table :flashcard_queues do |t|
      t.references :user, foreign_key: true
      t.references :article, foreign_key: true
      t.references :flashcard, foreign_key: true
      t.timestamps
    end
  end
end
