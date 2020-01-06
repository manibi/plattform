class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.string      :title
      t.text        :content
      t.references  :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
