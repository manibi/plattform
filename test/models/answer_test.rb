require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @answer = answers(:answer1)
  end

  test "valid answer" do
    assert @answer.valid?
  end

  test "should have in flashcard_id" do
    @answer.flashcard = nil
    assert_not @answer.valid?
  end

  test "should have a content text" do
    @answer.content = '  '
    assert_not @answer.valid?
  end
end
