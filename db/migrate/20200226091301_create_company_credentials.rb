class CreateCompanyCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :company_credentials do |t|
      t.string     :name
      t.string     :username
      t.string     :password
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
