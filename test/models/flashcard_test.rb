require 'test_helper'

class FlashcardTest < ActiveSupport::TestCase
  def setup
    @user = users(:bob)
    @flashcard = flashcards(:one)
    @second_article = articles(:second_article)
  end

  test "the truth" do
    assert @flashcard.valid?
  end

  test "should have in article_id" do
    @flashcard.article = nil
    assert_not @flashcard.valid?
  end

  test "should have a content text" do
    @flashcard.content = '  '
    assert_not @flashcard.valid?
  end

  test "should save one answered flashcard for a user" do
    answer = true

    # No saved flashcards for a user
    user_flashcards = UserFlashcard.where(user: @user).count
    assert_equal user_flashcards, 0

    # Answer a flashcard
    assert_difference "UserFlashcard.count", 1 do
      @flashcard.save_answer_for!(@user, answer)
    end
  end

  test "should reaset the flashcards from one article for one user" do
    answer = true
    second_flashcard_fist_article = flashcards(:two)
    flashcard_second_article = flashcards(:one_second_article)

    # Answer flashcards
    assert_difference "UserFlashcard.count", 3 do
      @flashcard.save_answer_for!(@user, answer)
      second_flashcard_fist_article.save_answer_for!(@user, answer)
      flashcard_second_article.save_answer_for!(@user, answer)
    end

    # Reset flashcard from first article
    assert_difference "UserFlashcard.count", -1 do
      Flashcard.reset_for!(@user, @second_article)
    end
  end

  test "should reset all flashcards for a user" do
    answer = true
    answer2 = false
    flashcard_second_article = flashcards(:one_second_article)

    # Answer 2 flashcards from 2 articles
    assert_difference "UserFlashcard.count", 2 do
      @flashcard.save_answer_for!(@user, answer)
      flashcard_second_article.save_answer_for!(@user, answer2)
    end

    # Reset flashcards
    assert_difference "UserFlashcard.count", -2 do
      Flashcard.reset_all_for!(@user)
    end
  end
end
