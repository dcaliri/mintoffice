# encoding: UTF-8
require 'test_helper'

class LedgerAccountTest < ActionDispatch::IntegrationTest
  fixtures :ledger_accounts

  test 'should visit ledger list' do
    visit '/'
    click_link '원장 관리'

    assert(page.has_content?('원장 관리'))
  end

  test 'should create a new ledger' do
    visit '/'
    click_link '원장 관리'
    click_link '신규 작성'

    fill_in "이름", with: "체크카드"
    select('비용', :from => 'ledger_account_category')

    click_button '원장 계정 만들기'

    assert(page.has_content?('체크카드'))
  end

  test 'should edit ledger' do
    visit '/'
    click_link '원장 관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "이름", with: "수정된 체크카드"
    select('수익', :from => 'ledger_account_category')

    click_button '원장 계정 수정하기'

    assert(page.has_content?('수정된 체크카드'))
  end

  test 'should destroy ledger' do
    visit '/'

    click_link '원장 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('현금(원장)'))
  end
end