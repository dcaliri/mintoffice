# encoding: UTF-8
require 'test_helper'

class PayrollTest < ActionDispatch::IntegrationTest
  fixtures :payrolls
  fixtures :payroll_items
  fixtures :payroll_categories

  test 'should visit payroll list' do
    visit '/'
    click_link '급여대장'

    assert(page.has_content?('김 관리'))
    assert(page.has_content?('2012-08-21'))
  end

  test 'should create a new payroll' do
    visit '/'
    click_link '급여대장'
    click_link '신규 작성'

    select '김 관리', from: 'payroll_employee_id'
    find_by_id('payroll_items_attributes_0_amount').set('100000')

    click_button 'Payroll 만들기'

    assert(page.has_content?('김 관리'))

    click_link '상세보기'

    assert(page.has_content?('₩100,000'))
  end

  test 'should edit payroll' do
    visit '/'
    click_link '급여대장'
    
    click_link '상세보기'

    click_link '수정하기'

    select '김 개똥', from: 'payroll_employee_id'
    find_by_id('payroll_items_attributes_0_amount').set('200000')

    click_button 'Payroll 수정하기'

    click_link '목록'

    assert(page.has_content?('김 개똥'))
  end

  test 'should edit payroll item' do
    visit '/'
    click_link '급여대장'
    click_link '상세보기'

    find('#list-table').click_link('수정하기')

    select '기타', from: 'payroll_item_payroll_category_id'
    fill_in '금액', with: '300000'

    click_button '급여 항목 수정하기'

    assert(page.has_content?('₩300,000'))
  end
end