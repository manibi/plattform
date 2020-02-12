class AddAnsweredCorrectToCustomExamAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exam_answers, :answered_correct_in_exam, :boolean, default: false
  end
end
