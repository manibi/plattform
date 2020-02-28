class CreateUserCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :user_credentials do |t|
      t.string     :username
      t.string     :password
      t.integer    :role
      t.references :user,       foreign_key: true
      t.references :company,    foreign_key: true
      t.references :profession, foreign_key: true
      t.timestamps
    end
  end
end
