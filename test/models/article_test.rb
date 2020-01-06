require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:bob)
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

  test 'should show an not bookmarked, not read article by a specific user' do
    @article.read_for?(@user)
    assert_not @article.read_for?(@user)
  end

  test 'should mark an not bookmarked article as read for a specific user' do
    @article.read_for!(@user)
    assert @article.read_for?(@user)
  end

  test 'should mark an bookmarked article as read for a specific user' do
    @article.bookmark_for!(@user)
    @article.read_for!(@user)
    assert @article.read_for?(@user)
  end

  test 'should bookmark an not read article a specific user' do
    @article.bookmark_for!(@user)
    assert @article.bookmarked_for?(@user)
  end

  test 'should unbookmark an not read article a specific user' do
    @article.bookmark_for!(@user)
    @article.unbookmark_for!(@user)
    assert_not @article.bookmarked_for?(@user)
  end
end
