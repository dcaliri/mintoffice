# encoding: UTF-8
require 'test_helper'

class EnrollReportTest < ActionDispatch::IntegrationTest
  
  test 'should show enroll_report list' do
    visit '/'
    click_link '입사지원'

    assert(page.has_content?('입사지원 관리'))
  end
end