# encoding: UTF-8
require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  fixtures :payments
  fixtures :employees
  fixtures :accounts
  fixtures :groups
  fixtures :employees_groups

  test 'should visit payment list for admin' do
    visit '/'
    
    visit '/payments'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit all payments for admin' do
    visit '/'
    
    visit '/payments'

    click_link '전체 보기'

    assert(page.has_content?('연봉 관리'))

    click_link '지급이 있는 사람들만 보기'

    assert(page.has_content?('연봉 관리'))

    find("tr.selectable").click

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit my payment' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should create new payment' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))

    click_link '기본급 작성'

    assert(page.has_content?('신규 작성'))

    fill_in "금액", with: "1500000"

    click_button '추가하기'

    assert(page.has_content?('새로운 기본급 입력'))

    click_button '추가하기'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should edit payment' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))

    click_link '수정'

    assert(page.has_content?('연봉 수정'))

    fill_in "금액", with: "100000"
    fill_in "내역", with: "수정된 내역"

    click_button '연봉 수정하기'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should destroy payment' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))

    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('연봉 관리'))
  end

  test 'should create new special bonus' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))

    click_link '특별 상여금 작성'

    assert(page.has_content?('특별상여금 작성'))

    select('25', :from => 'payment_pay_finish_3i')
    fill_in "금액", with: "100000"
    fill_in "내역", with: "테스트 내역"

    click_button '연봉 만들기'

    assert(page.has_content?('테스트 내역'))
  end

  test 'should visit hrinfo' do
    visit '/'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))

    click_link '인사정보'

    assert(page.has_content?('인사정보'))
  end
end