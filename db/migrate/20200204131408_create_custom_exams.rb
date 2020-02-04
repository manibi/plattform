class CreateCustomExams < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_exams do |t|
      t.text     :questions
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
