class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.text   :description
      t.references :topic, null: false, foreign_key: true
      t.timestamps
    end
  end
end
