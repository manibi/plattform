require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = articles(:first_article)
  end

  test 'valid article' do
    assert @article.valid?
  end

  test 'title should be present' do
    @article.title = ' '
    assert_not @article.valid?
  end

  test 'description should be present' do
    @article.description = ' '
    assert_not @article.valid?
  end

  test 'should have an topic_id key' do
    @article.topic = nil
    assert_not @article.valid?
  end
end
