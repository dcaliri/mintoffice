# encoding: UTF-8
require 'test_helper'

class PaymentRecordTest < ActionDispatch::IntegrationTest
  fixtures :payment_records
  fixtures :bankbooks

  test 'should visit PaymentRecord list' do
    visit '/'
    click_link '지급 조서 목록'

    assert(page.has_content?('월급 지급'))
    assert(page.has_content?('기업 통장'))
  end

  test 'should show PaymentRecord' do
    visit '/'
    click_link '지급 조서 목록'
    click_link '상세보기'

    assert(page.has_content?('월급 지급'))
    assert(page.has_content?('기업 통장'))
  end

  test 'should create a new PaymentRecord' do
    visit '/'
    click_link '지급 조서 목록'
    click_link '신규 작성'

    fill_in '이름', with: '지급 조서 목록 입력'
    select '농협 통장', from: 'payment_record_bankbook_id'

    click_button '지급조서 만들기'

    assert(page.has_content?('지급 조서 목록 입력'))
    assert(page.has_content?('농협 통장'))
  end

  test 'should edit PaymentRecord' do
    visit '/'
    click_link '지급 조서 목록'
    click_link '상세보기'

    click_link '수정하기'

    fill_in '이름', with: '지급 조서 목록 수정'
    select '농협 통장', from: 'payment_record_bankbook_id'

    click_button '지급조서 수정하기'

    assert(page.has_content?('지급 조서 목록 수정'))
    assert(page.has_content?('농협 통장'))
  end

  test 'should destroy PaymentRecord' do
    visit '/'
    click_link '지급 조서 목록'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('월급 지급'))
  end
end