require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
  end

  test 'should redirect when not logged in' do
    get root_path
    logout
    get articles_path
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
  end
end
