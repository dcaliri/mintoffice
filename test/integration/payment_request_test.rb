# encoding: UTF-8
require 'test_helper'

class PaymentRequestTest < ActionDispatch::IntegrationTest
  fixtures :payment_requests
  fixtures :bank_transactions
  fixtures :payment_records
  fixtures :dayworker_taxes
  fixtures :dayworkers
  fixtures :bankbooks

  test 'should visit payment request list' do
    visit '/'
    click_link '지급 청구 목록'

    assert(page.has_content?('테스트 은행'))
    assert(page.has_content?('1111-111-111111'))
    assert(page.has_content?('test holder'))
    assert(page.has_content?('11,000'))
    assert(page.has_content?('청구후 지급전'))
  end

  test 'should show payment request' do
    visit '/'
    click_link '지급 청구 목록'
    click_link '상세보기'

    assert(page.has_content?('테스트 은행'))
    assert(page.has_content?('1111-111-111111'))
    assert(page.has_content?('test holder'))
    assert(page.has_content?('11,000'))
    assert(page.has_content?('청구후 지급전'))
  end

  test 'should edit payment request' do
    visit '/'
    click_link '지급 청구 목록'
    click_link '상세보기'

    click_link '수정하기'

    fill_in '은행명', with: '수정 은행'
    fill_in '계좌번호', with: '2222-222-222222'
    fill_in '예금주', with: '예금주 수정'
    fill_in '금액', with: '101010'

    click_button '지급 청구 수정하기'

    assert(page.has_content?('수정 은행'))
    assert(page.has_content?('2222-222-222222'))
    assert(page.has_content?('예금주 수정'))
    assert(page.has_content?('101,010'))
    assert(page.has_content?('청구후 지급전'))
  end

  test 'should complete payment request' do
    visit '/'
    click_link '지급 청구 목록'
    click_link '상세보기'

    click_link '지급 완료'

    assert(page.has_content?('지급을 완료하였습니다.'))
  end

  test 'should destroy payment request' do
    visit '/'
    click_link '지급 청구 목록'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('테스트 은행'))
  end

  test 'should export excel file' do
    switch_to_selenium

    visit '/'
    click_link '회계관리'
    click_link '지급 청구 목록'
    click_link 'Excel'

    assert(page.has_content?('지급 청구 목록'))
  end

  test 'should create auto generation to bank_transactions' do
    PaymentRequest.destroy_all

    visit '/'
    click_link '지급 청구 목록'
    click_link '신규 작성'

    fill_in '은행명', with: '기업 은행'
    fill_in '계좌번호', with: '321-123-123456'
    fill_in '예금주', with: 'test'
    fill_in '금액', with: '160'
    
    click_button '지급 청구 만들기'

    click_link '거래내역'
    
    assert(page.has_content?('321-123-123456'))
    assert(page.has_content?('160'))
    assert(page.has_content?('이자'))
    assert(page.has_content?('e만기'))
    assert(page.has_content?('기업 은행'))
  end

  test 'should create auto generation to payment record' do
    PaymentRequest.destroy_all

    visit '/'
    click_link '지급 조서 목록'
    click_link '상세보기'

    click_link '지급청구 생성'

    fill_in '금액', with: '20000'
    
    click_button '지급 청구 만들기'

    click_link '지급 근거'
    
    assert(page.has_content?('월급 지급'))
    assert(page.has_content?('기업 통장'))

    click_link '지급청구 보기'

    assert(page.has_content?('기업은행'))
    assert(page.has_content?('274-062855-01-012'))
    assert(page.has_content?('김 기업'))
    assert(page.has_content?('20,000'))
  end

  test 'should create auto generation to dayworker tax' do
    PaymentRequest.destroy_all

    visit '/'
    click_link '사업소득원천징수 관리'
    click_link '상세보기'

    click_link '지급청구 생성'

    fill_in '은행명', with: '기업 은행'
    fill_in '계좌번호', with: '321-123-123456'
    fill_in '예금주', with: 'test'
    
    click_button '지급 청구 만들기'

    click_link '지급 근거'
    
    assert(page.has_content?('payment'))
    assert(page.has_content?('₩30,000'))
    assert(page.has_content?('₩990'))
    assert(page.has_content?('₩29,010'))

    click_link '지급청구 보기'

    assert(page.has_content?('기업 은행'))
    assert(page.has_content?('321-123-123456'))
    assert(page.has_content?('test'))
  end
end