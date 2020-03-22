class MoveTriesToFlashcardsQueue < ActiveRecord::Migration[6.0]
  def change
    add_column :flashcard_queues, :tries, :integer, default: 0
    remove_column :user_flashcards, :tries
  end
end
