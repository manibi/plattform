require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @profession = professions(:developer)
    @user = @profession.users.build(username: 'uniq_string_2', password: 'password')
  end

  test 'should redirect if not logged in' do
    get profile_path
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update if not logged in' do
    @user.save
    patch user_path(@user), params: { user: { first_name: 'Should not work' }}
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should have update profile and change password links on the profile page' do
    @user.save
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
    @user.update_attribute(:first_name, nil)
    login(@user)
    get profile_edit_path
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { first_name: first_name,
                                              exam_date: Date.today }}
    assert_redirected_to profile_path
    @user.reload
    assert_equal first_name, @user.first_name
  end
end
