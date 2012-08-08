# encoding: UTF-8
require 'test_helper'

class BankTransactionTest < ActionDispatch::IntegrationTest
  fixtures :bank_accounts
  fixtures :bank_transactions
  fixtures :bank_transfers

  test "should create except_columns" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    click_link '컬럼 선택하기'

    uncheck('적요')
    uncheck('상대 은행')
    uncheck('거래점명')
    uncheck('상대 계좌번호')
    uncheck('수표 어음금액')
    uncheck('CMS 코드')

    click_button '태그 만들기'
    
    alert = page.driver.browser.switch_to.alert
    alert.send_keys("test tag")
    alert.accept

    assert(page.has_content?('입출금 내역'))
  end
end