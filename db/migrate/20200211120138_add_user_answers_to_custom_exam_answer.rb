class AddUserAnswersToCustomExamAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exam_answers, :user_answers, :text
  end
end
