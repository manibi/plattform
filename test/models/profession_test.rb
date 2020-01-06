require 'test_helper'

class ProfessionTest < ActiveSupport::TestCase
  def setup
    @profession = professions(:developer)
  end

  test 'valid profession' do
    assert @profession.valid?
  end

  test 'name should be present' do
    @profession.name = ' '
    assert_not @profession.valid?
  end
end
