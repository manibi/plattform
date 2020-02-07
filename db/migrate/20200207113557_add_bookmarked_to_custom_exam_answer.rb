class AddBookmarkedToCustomExamAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exam_answers, :bookmarked, :boolean, default: false
  end
end
