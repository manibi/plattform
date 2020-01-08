require 'test_helper'

class LibraryInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @article = articles(:first_article)
  end

  test "should read, bookmark, see articles from library - logged in user" do
    user_topics = @user.profession.topics
    # article = user_topics.first.articles.first

    # Login
    get root_path
    login(@user)
    assert_redirected_to welcome_path

    # Navigate to the library page
    get articles_path
    assert_response :success
    assert_template "articles/index"

    # See all upcoming articles, number of upcoming articles
    all_user_articles = user_topics.pluck.flatten.size - user_topics.size
    assert_equal all_user_articles, @user.upcoming_articles.count
    assert_match "Upcoming Articles #{all_user_articles}", response.body

    # See bookmarked articles
    # No bookmarks
    assert_equal @user.bookmarked_articles.count, 0
    assert_match "Bookmarked Articles 0", response.body

    # Read one article
    get article_path(@article)
    post read_article_path(@article)
    assert assert_equal @user.read_articles.count, 1
    assert_redirected_to article_path(@article)

    # Display one read article on library page
    get articles_path
    assert_match "Read Articles 1", response.body

    # Bookmark one article
    get article_path(@article)
    post bookmark_article_path(@article)
    assert assert_equal @user.bookmarked_articles.count, 1
    assert_redirected_to article_path(@article)

    # Display one bookmarked article on library page
    get articles_path
    assert_match "Bookmarked Articles 1", response.body

    # Display upcoming articles after reading one article
    assert_equal (all_user_articles - 1), @user.upcoming_articles.count
    assert_match "Upcoming Articles #{all_user_articles - 1}", response.body

    # Unbookmark one article
    get article_path(@article)
    patch unbookmark_article_path(@article)
    assert assert_equal @user.bookmarked_articles.count, 0
    assert_redirected_to article_path(@article)

    # Display one bookmarked article on library page
    get articles_path
    assert_match "Bookmarked Articles 0", response.body

    # Display upcoming articles after unbookmarking one article, with one article read
    # Upcoming articles should not change
    assert_equal (all_user_articles - 1), @user.upcoming_articles.count
    assert_match "Upcoming Articles #{all_user_articles-1}", response.body
  end
end
