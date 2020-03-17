class MigrateChapterContentToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :chapters, :content, :content_old
    Chapter.all.each do |chapter|
      chapter.update_attribute(:content, simple_format(chapter.content_old))
    end
    remove_column :chapters, :content_old
  end
end
