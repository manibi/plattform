class AddAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :birth_date, :date
    add_column :users, :exam_day, :date
  end
end
