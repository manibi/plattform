require 'test_helper'

class FlashcardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @flashcard = flashcards(:one)
    @article = @flashcard.article
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

  test "should redirect if not logged in" do
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

    # Answer question
    assert_difference "UserFlashcard.count", 1 do
      post answer_article_flashcard_path(@article, @flashcard),
      params: { article: @article,
                flashcard: @flashcard,
                correct: true
      }
    end
  end

  test "should reject the answer to a flashcard if not logged in" do
    # logged out
    get root_path
    logout

    # Answer question
    assert_difference "UserFlashcard.count", 0 do
      post answer_article_flashcard_path(@article, @flashcard),
      params: { article: @article,
                flashcard: @flashcard,
                correct: true
      }
    end
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
