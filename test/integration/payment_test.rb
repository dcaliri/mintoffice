# encoding: UTF-8
require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  fixtures :payments

  test 'should visit payment list for admin' do
    visit '/'
    visit '/payments'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit all payments for admin' do
    visit '/'
    visit '/payments'
    click_link '전체 보기'

    assert(page.has_content?('김 관리'))

    click_link '지급이 있는 사람들만 보기'

    click_link '상세보기'

    assert(page.has_content?('김 관리'))
  end

  test 'should visit my payment' do
    visit '/'
    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should create new payment' do
    visit '/'
    click_link '연봉 관리'
    click_link '기본급 작성'

    fill_in "금액", with: "1500000"

    click_button '추가하기'
    click_button '추가하기'

    assert(page.has_content?('1,500,000'))
    assert(page.has_content?(get_payment_day))
  end

  test 'should edit payment' do
    visit '/'
    click_link '연봉 관리'

    click_link '수정'

    fill_in "금액", with: "100000"
    fill_in "내역", with: "수정된 내역"

    click_button '연봉 수정하기'

    assert(page.has_content?('100,000'))
    assert(page.has_content?('수정된 내역'))
  end

  test 'should destroy payment' do
    visit '/'
    click_link '연봉 관리'

    disable_confirm_box

    click_link '삭제'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should create new special bonus' do
    visit '/'
    click_link '연봉 관리'

    click_link '특별 상여금 작성'

    select('25', :from => 'payment_pay_finish_3i')
    fill_in "금액", with: "100000"
    fill_in "내역", with: "테스트 내역"

    click_button '연봉 만들기'

    assert(page.has_content?('100,000'))
    assert(page.has_content?('테스트 내역'))
  end

  test 'should visit hrinfo' do
    visit '/'

    click_link '연봉 관리'
    click_link '인사정보'

    assert(page.has_content?('김 관리'))
    assert(page.has_content?('사장'))
  end

  test 'should show a new payment in 9 month' do
    visit '/payments/2'
    click_link '기본급 작성'

    select "#{Time.zone.now.year}", from: 'payments_join_at_1i'
    select '8월', from: 'payments_join_at_2i'
    select '21', from: 'payments_join_at_3i'

    select "#{Time.zone.now.year}", from: 'payments_pay_finish_1i'
    select '8월', from: 'payments_pay_finish_2i'
    select '29', from: 'payments_pay_finish_3i'

    fill_in "금액", with: "1500000"

    click_button '추가하기'
    click_button '추가하기'

    assert(!page.has_content?('2012.08'))
    assert(page.has_content?('2012.09.25'))
  end
end