# encoding: UTF-8
require 'test_helper'

class PayrollTest < ActionDispatch::IntegrationTest

  test 'should visit payroll_category list' do
    visit '/'
    click_link '급여 구분 관리'

    assert(page.has_content?('급여 구분 관리'))
  end

  test 'should visit payroll list' do
    visit '/'
    click_link '급여대장'

    assert(page.has_content?('급여대장'))
  end
end