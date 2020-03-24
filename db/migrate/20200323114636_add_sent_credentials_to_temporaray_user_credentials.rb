class AddSentCredentialsToTemporarayUserCredentials < ActiveRecord::Migration[6.0]
  def change
    add_column :temporary_user_credentials, :sent_credentials, :boolean, default: false
  end
end
