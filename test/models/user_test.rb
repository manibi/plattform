require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: 'uniq_string_2', password: 'password')
    # @another_user = User.new(username: 'uniq_string_3', password: 'password')
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'username should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'username should be present' do
    @user.username = ' '
    assert_not @user.valid?
  end

  test 'username should be longer than 6 characters' do
    @user.username = 'a' * 5
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com use@mozubi.app USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test 'password should be present' do
    @user.password = '  '
    assert_not @user.valid?
  end

  test 'password should be longer than 6 characters' do
    @user.password = 'a' * 5
    assert_not @user.valid?
  end
end
