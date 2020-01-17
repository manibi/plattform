require 'test_helper'

class FlashcardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @answer1 = answers(:answer1)
    @answer2 = answers(:answer2)
    @answer3 = answers(:answer3)
    @article = articles(:first_article)
    @flashcard = flashcards(:one_multiple_choice)
    @flashcard.answers << [@answer1, @answer2, @answer3]
    @flashcard.save!
    @flashcard.update(correct_answers: [@answer1.id])

  end

  test "should display one flahscard if logged in" do
    # successful login
    get root_path
    login(@user)
    assert_redirected_to welcome_path

    # Display flashcard
    get article_flashcard_path(@article, @flashcard)
    assert :success
    assert_template "flashcards/show"
  end

  test "should from flahscard page redirect if not logged in" do
    # logged out
    get root_path
    logout

    # Display flashcard
    get article_flashcard_path(@article, @flashcard)
    assert :redirect
    follow_redirect!
    assert_not flash.empty?
    assert_template "devise/sessions/new"
  end

  test "should answer a flashcard if logged in" do
    # successful login
    get root_path
    login(@user)
    assert_redirected_to welcome_path
    assert_kind_of Array, @flashcard.correct_answers
    assert @flashcard.correct_answers.size == 1

    @correct_answered_flashcards = @user.correct_answered_flashcards_for(@article)
    assert_difference "@correct_answered_flashcards.count", 1 do
      @flashcard.save_answer_for!(@user, true)
    end
  end

  test "should reject the answer to a flashcard if not logged in" do
    # logged out
    get root_path
    logout

    @flashcard.save_answer_for!(@user, true)
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_template "pages/landing_page"
  end

  test "should redirect from results page if not logged in" do
    # logged out
    get root_path
    logout

    get article_quiz_results_path(@article)
    assert_redirected_to new_user_session_path
  end

  test "should show the  results page if logged in" do
    # successful login
    get root_path
    login(@user)
    assert_redirected_to welcome_path

    get article_quiz_results_path(@article)
    assert_response :success
  end
end
