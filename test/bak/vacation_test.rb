# encoding: UTF-8
require 'test_helper'

class VacationTest < ActionDispatch::IntegrationTest
  test 'show visit root page' do
    visit '/'
    click_link '연차 정보'

	  assert(page.has_content?('연차 정보'))  
  end
end