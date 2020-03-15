class CreateTemporaryUserCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :temporary_user_credentials do |t|
      t.string     :username
      t.string     :password
      t.string     :first_name
      t.string     :last_name
      t.string     :company_name
      t.string     :school_name
      t.string     :email
      t.date       :birth_date
      t.date       :exam_date
      t.integer    :role

      t.references :company,    foreign_key: true
      t.references :profession, foreign_key: true

      t.timestamps
    end
  end
end
