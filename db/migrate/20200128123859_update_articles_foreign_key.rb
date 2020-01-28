class UpdateArticlesForeignKey < ActiveRecord::Migration[6.0]
  def change
    remove_reference :articles, :topic, index: true, foreign_key: true
    add_reference    :articles, :category, foreign_key: true
  end
end
