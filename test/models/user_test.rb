require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @profession = professions(:developer)
    @user = users(:bob)
    @topic = topics(:first_topic)
    @flashcard = flashcards(:one_multiple_choice)
    @flashcard2 = flashcards(:two)
  end

  test 'should be valid user' do
    assert @user.valid?
  end

  test 'profession id should be present' do
    @user.profession = nil
    assert_not @user.valid?
  end

  test 'username should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'username should be present' do
    @user.username = ' '
    assert_not @user.valid?
  end

  test 'username should be longer than 6 characters' do
    @user.username = 'a' * 5
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com use@mozubi.app USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test 'password should be present' do
    @user.password = '  '
    assert_not @user.valid?
  end

  test 'password should be longer than 6 characters' do
    @user.password = 'a' * 5
    assert_not @user.valid?
  end

  # Return a collection of articles read by a user
  test "should return users read articles" do
    # No read articles
    assert_equal @user.read_articles.count, 0

    # Read 2 articles
    article1 = @topic.articles.first
    article2 = @topic.articles.last
    article1.read_for!(@user)
    article2.read_for!(@user)

    assert_equal @user.read_articles.count, 2
  end

  # Return a collection of articles bookmarked by a user
  test "should return users bookmarked articles" do
    # No bookmarked articles
    assert_equal @user.bookmarked_articles.count, 0

    # Bookmark 2 articles
    article1 = @topic.articles.first
    article2 = @topic.articles.last
    article1.bookmark_for!(@user)
    article2.bookmark_for!(@user)

    assert_equal @user.bookmarked_articles.count, 2
  end

  # Return a collection of upcoming articles(not bookmarked or not read) for a user
  test "should return users upcoming articles" do
    profession_topics = @profession.topics
    # Remove the topic names and count the articles
    all_articles = profession_topics.pluck.flatten.size - profession_topics.size
    # No read or bookmarked articles
    assert_equal @user.upcoming_articles.count, all_articles

    # Read and bookmark 2 articles
    article1 = @topic.articles.first
    article2 = @topic.articles.last
    article1.read_for!(@user)
    article2.bookmark_for!(@user)

    assert_equal @user.upcoming_articles.count, (all_articles - 2)
  end

  test "should return answered flashcards for a user" do
    answer = false
    answer2 = false

    # Answer 2 flashcards
    @flashcard.save_answer_for!(@user, answer)
    @flashcard2.save_answer_for!(@user, answer2)
    answered_flashcards = @user.answered_flashcards.count
    assert_equal answered_flashcards, 2
  end

  test "should return right answered flashcards for a user" do
    answer = true

    # Answer a flashcard
    @flashcard.save_answer_for!(@user, answer)
    right_answered_flashcards = @user.right_answered_flashcards.count
    assert_equal right_answered_flashcards, 1
  end

  test "should return wrong answered flashcards for a user" do
    answer = false

    # Answer a flashcard
    @flashcard.save_answer_for!(@user, answer)
    answered_flashcards = @user.wrong_answered_flashcards.count
    assert_equal answered_flashcards, 1
  end
end
