# encoding: UTF-8
require 'test_helper'

class PayrollCategoriesTest < ActionDispatch::IntegrationTest
  fixtures :payrolls
  fixtures :payroll_items
  fixtures :payroll_categories

  test 'should visit payroll_category list' do
    visit '/'
    click_link '급여대장'
    click_link '급여 구분 관리'

    assert(page.has_content?('지급항목'))
    assert(page.has_content?('기타'))
  end

  test 'should create a new payroll_category' do
    visit '/'
    click_link '급여대장'
    click_link '급여 구분 관리'

    click_link '신규 작성'

    select '지급항목', from: 'payroll_category_prtype'
    select '기타', from: 'payroll_category_code'
    fill_in '항목이름', with: '항목이름 입력 테스트'

    click_button '급여구분 만들기'

    assert(page.has_content?('지급항목'))
    assert(page.has_content?('기타'))
    assert(page.has_content?('항목이름 입력 테스트'))
  end

  test 'should edit payroll_category' do
    visit '/'
    click_link '급여대장'
    click_link '급여 구분 관리'

    click_link '상세보기'
    click_link '수정하기'


    select '공제항목', from: 'payroll_category_prtype'
    select '기타', from: 'payroll_category_code'
    fill_in '항목이름', with: '항목이름 수정 테스트'

    click_button '급여구분 수정하기'

    assert(page.has_content?('공제항목'))
    assert(page.has_content?('기타'))
    assert(page.has_content?('항목이름 수정 테스트'))
  end

  test 'should fail to edit payroll_category' do
    visit '/'
    click_link '급여대장'
    click_link '급여 구분 관리'

    click_link '상세보기'
    click_link '수정하기'

    select '공제항목', from: 'payroll_category_prtype'
    select '기본급', from: 'payroll_category_code'
    fill_in '항목이름', with: '항목이름 수정 테스트'

    click_button '급여구분 수정하기'

    assert(page.has_content?('공제항목에 잘못된 연결코드를 선택하였습니다.'))
  end

  test 'should destroy payroll_category' do
    visit '/'
    click_link '급여대장'
    click_link '급여 구분 관리'

    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('지급항목'))
    assert(!page.has_content?('기타'))
  end
end