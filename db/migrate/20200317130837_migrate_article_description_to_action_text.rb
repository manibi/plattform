class MigrateArticleDescriptionToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :articles, :description, :content_old
    Article.all.each do |article|
      article.update_attribute(:description, simple_format(article.content_old))
    end
    remove_column :articles, :content_old
  end
end
