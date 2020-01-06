require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @article = articles(:first_article)
  end

  test 'should redirect when not logged in' do
    get root_path
    logout
    get articles_path
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
  end

  test 'should render one article if logged in' do
    # successful login
    get root_path
    login(@user)
    assert_response :redirect

    get article_path(@article)
    assert_response :success
    assert_template 'articles/show'
    assert_match @article.title, response.body
  end

  test "should bookmark an article" do
    # successful login
    get root_path
    login(@user)
    assert_response :redirect

    # article page
    get article_path(@article)
    assert_template "articles/show"

    # bookmark an article
    post bookmark_article_path(@article), params: { article: {
      user: @user,
      article: @article,
      bookmarked: true
    }}

    assert @article.bookmarked_for?(@user)
  end

  test "should read an article" do
    # successful login
    get root_path
    login(@user)
    assert_response :redirect

    # article page
    get article_path(@article)
    assert_template "articles/show"

    # read an article
    post read_article_path(@article), params: { article: {
      user: @user,
      article: @article,
      read: true
    }}

    assert @article.read_for?(@user)
  end

  test "should unbookmark an article" do
    # successful login
    get root_path
    login(@user)
    assert_response :redirect

    # article page
    get article_path(@article)
    assert_template "articles/show"

    # unbookmark an article
    patch unbookmark_article_path(@article), params: { article: {
      user: @user,
      article: @article,
      bookmarked: false
    }}

    assert_not @article.bookmarked_for?(@user)
  end

  test "should mark an article as unread" do
    # successful login
    get root_path
    login(@user)
    assert_response :redirect

    # article page
    get article_path(@article)
    assert_template "articles/show"

    # read an article
    patch unread_article_path(@article), params: { article: {
      user: @user,
      article: @article,
      read: false
    }}

    assert_not @article.read_for?(@user)
  end
end
