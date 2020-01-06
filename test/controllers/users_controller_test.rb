require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'should login with given username and password' do
    get root_path
    login(@user)
    assert_response :redirect
  end
end
