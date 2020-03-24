class AddAnotherProfessionToTemporaryUserCredentials < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_credentials, :another_profession, :text
  end
end
