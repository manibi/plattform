class CreateCustomExamAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_exam_answers do |t|
      t.boolean    :answered, default: false
      t.boolean    :correct, default: false
      t.references :custom_exam, foreign_key: true
      t.references :flashcard, foreign_key: true

      t.timestamps
    end
  end
end
