require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'should redirect if not logged in' do
    get profile_path
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update if not logged in' do
    patch user_path(@user), params: { user: { first_name: 'Should not work' }}
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should have update profile and change password links on the profile page' do
    login(@user)
    assert_response :redirect
    follow_redirect!
    assert_select 'a[href=?]', profile_path
    get profile_path
    assert_select 'a[href=?]', profile_edit_path
    assert_select 'a[href=?]', edit_user_registration_path
  end

  test 'should update if logged in' do
    first_name = 'Bobby'
    @user.save
    login(@user)
    get profile_edit_path
    assert_response :success

    patch user_path(@user), params: { user: {first_name: first_name }}
    assert_redirected_to profile_path
    @user.reload
    assert_equal first_name, @user.first_name
  end
end
