class AddAttributesToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :username, :string
    add_column :companies, :name, :string
    add_column :companies, :address, :string
    add_column :companies, :phone_number, :string
    add_column :companies, :contact_person_name, :string

    add_index :companies, :username, unique: true
    remove_index :companies, :email
    add_index :companies, :email
  end
end
