require 'test_helper'

class UsersLogoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end
  test 'should log out user' do
    get root_path
    login(@user)
    assert_response :redirect
    follow_redirect!
    logout
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
