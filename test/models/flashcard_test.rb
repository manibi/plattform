require 'test_helper'

class FlashcardTest < ActiveSupport::TestCase
  def setup
    @flashcard = flashcards(:one)
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
end
