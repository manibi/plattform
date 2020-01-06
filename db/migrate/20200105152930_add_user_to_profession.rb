class AddUserToProfession < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :profession, foreign_key: true
  end
end
