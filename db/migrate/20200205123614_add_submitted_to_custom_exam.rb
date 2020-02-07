class AddSubmittedToCustomExam < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exams, :submitted, :boolean, default: false
  end
end
