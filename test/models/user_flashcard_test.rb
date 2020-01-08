require 'test_helper'

class UserFlashcardTest < ActiveSupport::TestCase
  def setup
    @user = users(:bob)
    @flashcard = flashcards(:one)
    @user_flashcard = @flashcard.user_flashcards.create!(user: @user)
  end

  test "flashcard_id should be present" do
    @user_flashcard.flashcard = nil
    assert_not @user_flashcard.valid?
  end

  test "user_id should be present" do
    @user_flashcard.user = nil
    assert_not @user_flashcard.valid?
  end

  test "should be valid" do
    assert @user_flashcard.valid?
  end
end
