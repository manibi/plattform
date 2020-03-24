class AddFeedbackToTemporaryUserCredentials < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_credentials, :feedback, :text
  end
end
