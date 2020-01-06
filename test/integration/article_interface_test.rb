require 'test_helper'

class ArticleInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user     = users(:bob)
    @article  = articles(:first_article)
  end

  test "article page interface" do
    login(@user)
    get article_path(@article)
    assert_template "articles/show"

    # display title, description
    assert @article.title, response.body
    assert @article.description, response.body

    # display chapters
    @article.chapters.each do |chapter|
      assert chapter.title, response.body
      assert chapter.content, response.body
    end

    # display bookmark, unbookmark links
    assert_select "a[href=?]", bookmark_article_path(@article)
    post bookmark_article_path(@article), params: { article: {
      user: @user,
      article: @article,
      bookmarked: true
    }}
    follow_redirect!
    assert_select "a[href=?]", unbookmark_article_path(@article)
  end
end
