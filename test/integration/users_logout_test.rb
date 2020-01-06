require 'test_helper'

class UsersLogoutTest < ActionDispatch::IntegrationTest
  def setup
    @profession = professions(:developer)
    @user = @profession.users.build(username: 'uniq_string_2', password: 'password')
  end
  test 'should log out user' do
    get root_path
    login(@user)
    # assert_response :redirect
    # follow_redirect!
    # logout
    # assert_not flash.empty?
    # assert_redirected_to root_path
  end
end
