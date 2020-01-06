require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  def setup
    @article = articles(:first_article)
    @chapter = @article.chapters.create!({
      title:   'Active Record',
      content: 'Active record stuff'
    })
  end

  test 'valid chapter' do
    assert @chapter.valid?
  end

  test 'article_id should be present' do
    @chapter.save
    @chapter.article = nil
    assert_not @chapter.valid?
  end

  test 'title should be present' do
    @chapter.title = '  '
    assert_not @chapter.valid?
  end

  test 'content should be present' do
    @chapter.content = '  '
    assert_not @chapter.valid?
  end
end
