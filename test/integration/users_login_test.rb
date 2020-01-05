require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'should login with given username and password' do
    get root_path
    login(@user)
    assert_response :redirect
  end

  test 'should redirect to update profile if the exam date is not present' do
    @user.exam_date = nil
    @user.save
    get root_path
    assert_response :success

    login(@user)
    assert_redirected_to welcome_path
    follow_redirect!
    assert_template 'pages/welcome'
  end

  test 'should redirect to dashboard if exam date is present' do
    @user.exam_date = Date.today
    @user.save
    get root_path
    login(@user)
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_template 'pages/dashboard'
    assert_response :success
  end
end
