class RenameExamDayToExamDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :exam_day, :exam_date
  end
end
