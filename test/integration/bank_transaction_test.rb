# encoding: UTF-8
require 'test_helper'

class BankTransactionTest < ActionDispatch::IntegrationTest
  fixtures :bank_accounts
  fixtures :bank_transactions
  fixtures :bank_transfers

  test "should visit bank_transaction list" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    
    assert(page.has_content?('입출금 내역'))
  end

  test "should velified bank_transactions" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    click_link '검증하기'

    assert(page.has_content?('입출금 내역 검증'))

    find("tr.selectable").click

    assert(page.has_content?('입출금 내역'))
  end

  test "should not velified bank_transactions" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    click_link '검증하기'

    assert(!page.has_content?('false'))

    click_link '돌아가기'
    click_link '입출금 내역 올리기'

    select('2011', :from => 'bank_transaction_transacted_at_1i')
    select('1월', :from => 'bank_transaction_transacted_at_2i')
    select('26', :from => 'bank_transaction_transacted_at_3i')
    select('11', :from => 'bank_transaction_transacted_at_4i')
    select('11', :from => 'bank_transaction_transacted_at_5i')
    fill_in "적요", with: "적요 입력 테스트"
    fill_in "입금액", with: "0"
    fill_in "출금액", with: "160"
    fill_in "내용", with: "내용 입력 테스트"
    fill_in "잔액", with: "5"
    fill_in "거래점명", with: "GS25"
    fill_in "상대 계좌번호", with: "123-321-1234"
    fill_in "상대 은행", with: "기업은행"
    fill_in "수표 어음금액", with: ""
    fill_in "CMS 코드", with: ""

    click_button '입출금 내역 만들기'

    click_link '수정'

    fill_in "잔액", with: "50"

    click_link '돌아가기'
    click_link '검증하기'

    assert(page.has_content?('false'))
  end

  test "should create except_columns" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    click_link '컬럼 선택하기'

    assert(page.has_content?('이자'))
    assert(page.has_content?('하나 은행'))

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

    assert(!page.has_content?('이자'))
    assert(!page.has_content?('하나 은행'))
  end

  test "should create a new bank_transactions" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    click_link '입출금 내역 올리기'

    select('2011', :from => 'bank_transaction_transacted_at_1i')
    select('1월', :from => 'bank_transaction_transacted_at_2i')
    select('26', :from => 'bank_transaction_transacted_at_3i')
    select('11', :from => 'bank_transaction_transacted_at_4i')
    select('11', :from => 'bank_transaction_transacted_at_5i')
    fill_in "적요", with: "적요 입력 테스트"
    fill_in "입금액", with: "0"
    fill_in "출금액", with: "160"
    fill_in "내용", with: "내용 입력 테스트"
    fill_in "잔액", with: "5"
    fill_in "거래점명", with: "GS25"
    fill_in "상대 계좌번호", with: "123-321-1234"
    fill_in "상대 은행", with: "기업은행"

    click_button '입출금 내역 만들기'

    assert(page.has_content?('적요 입력 테스트'))
    assert(page.has_content?('160'))
    assert(page.has_content?('내용 입력 테스트'))
    assert(page.has_content?('GS25'))
    assert(page.has_content?('123-321-1234'))
    assert(page.has_content?('기업은행'))
  end

  test "should edit bank_transaction" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    find("tr.selectable").click
    click_link '수정'

    select('2012', :from => 'bank_transaction_transacted_at_1i')
    select('2월', :from => 'bank_transaction_transacted_at_2i')
    select('27', :from => 'bank_transaction_transacted_at_3i')
    select('12', :from => 'bank_transaction_transacted_at_4i')
    select('12', :from => 'bank_transaction_transacted_at_5i')
    fill_in "적요", with: "적요 수정 테스트"
    fill_in "입금액", with: "0"
    fill_in "출금액", with: "160"
    fill_in "내용", with: "내용 수정 테스트"
    fill_in "잔액", with: "5"
    fill_in "거래점명", with: "수정된 거래점명"
    fill_in "상대 계좌번호", with: "123-321-1234"
    fill_in "상대 은행", with: "수정된 상대 은행"

    click_button '입출금 내역 수정하기'

    assert(page.has_content?('적요 수정 테스트'))
    assert(page.has_content?('160'))
    assert(page.has_content?('내용 수정 테스트'))
    assert(page.has_content?('수정된 거래점명'))
    assert(page.has_content?('수정된 상대 은행'))
  end

  test "should destroy bank_transaction" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    
    find("tr.selectable").click

    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('입출금 내역이 없습니다'))
  end

  test "should upload an excel file" do
    BankTransaction.destroy_all

    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
   
    click_link '엑셀 파일로 올리기'
    path = File.join(::Rails.root, "test/fixtures/excels/bank_transaction_fixture.xls") 
    attach_file("upload_file", path)

    click_button '미리보기'
    click_button '엑셀 파일'

    assert(page.has_content?('e_만기'))
    assert(page.has_content?('₩30,360,000'))
    assert(page.has_content?('엘지전자(주)'))
  end
end