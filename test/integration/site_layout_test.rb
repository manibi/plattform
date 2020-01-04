require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'should display the landing page with login link' do
    get root_path
    assert_template 'pages/landing_page'
    assert_select 'a[href=?]', new_user_session_path
  end
end
