require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = topics(:first_topic)
  end

  test 'valid topic' do
    assert @topic.valid?
  end

  test 'profession id should be present' do
    @topic.profession = nil
    assert_not @topic.valid?
  end
end
