ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # Log in user
  def login(user)
    post user_session_path, params: { user: {
      username: user.username,
      password: 'password'
    }}
  end

  # Log out user
  def logout
    delete destroy_user_session_path
  end
end
