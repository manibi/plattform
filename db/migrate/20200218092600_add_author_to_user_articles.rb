class AddAuthorToUserArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :user_articles, :author, :boolean, default: false
    add_column :user_articles, :editor, :boolean, default: false
  end
end
