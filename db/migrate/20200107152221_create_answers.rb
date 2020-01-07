class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text       :content
      t.boolean    :right_answer, default: false
      t.references :flashcard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
