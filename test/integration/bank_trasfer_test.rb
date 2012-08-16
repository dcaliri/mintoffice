# encoding: UTF-8
require 'test_helper'

class BankTransferTest < ActionDispatch::IntegrationTest
  fixtures :bank_accounts
  fixtures :bank_transactions
  fixtures :bank_transfers
  fixtures :projects
  fixtures :project_assign_infos

  test "should visit bank_transfer list" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
    
    assert(page.has_content?('외부 내용'))
    assert(page.has_content?('임의 내용'))
    assert(page.has_content?('적금 만기'))
  end

  test "should create except_columns" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
    click_link '컬럼 선택하기'

    assert(page.has_content?('28505013648'))
    assert(page.has_content?('KRW'))

    uncheck('이체구분')
    uncheck('출금계좌')
    uncheck('입금계좌')
    uncheck('수수료')
    uncheck('입금통장표시내용')
    uncheck('CMS코드')
    uncheck('통화 코드')

    click_button '태그 만들기'

    alert = page.driver.browser.switch_to.alert
    alert.send_keys("test tag")
    alert.accept

    page.driver.send(:sleep, 1)

    assert(!page.has_content?('28505013648'))
    assert(!page.has_content?('KRW'))
  end

  test "should create a new bank_transfer" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
    click_link '이체 내역 올리기'

    fill_in "이체구분", with: "이체구분 입력 테스트"
    select('2011', :from => 'bank_transfer_transfered_at_1i')
    select('1월', :from => 'bank_transfer_transfered_at_2i')
    select('26', :from => 'bank_transfer_transfered_at_3i')
    select('11', :from => 'bank_transfer_transfered_at_4i')
    select('11', :from => 'bank_transfer_transfered_at_5i')
    fill_in "처리결과", with: "처리결과 입력 테스트"
    fill_in "출금계좌", with: "123-321-1234"
    fill_in "입금은행", with: "테스트 은행"
    fill_in "입금계좌", with: "321-123-4321"
    fill_in "수수료", with: "1200"
    fill_in "오류금액", with: "0"
    select('2011', :from => 'bank_transfer_registered_at_1i')
    select('1월', :from => 'bank_transfer_registered_at_2i')
    select('26', :from => 'bank_transfer_registered_at_3i')
    select('11', :from => 'bank_transfer_registered_at_4i')
    select('11', :from => 'bank_transfer_registered_at_5i')
    fill_in "거래메모", with: "거래메모 입력 테스트"
    fill_in "출금통장표시내용", with: "출금통장표시내용 입력 테스트"
    fill_in "입금통장표시내용", with: "입금통장표시내용 입력 테스트"
    fill_in "입금인성명", with: "입금인성명 입력 테스트"

    click_button '이체 내역 만들기'

    assert(page.has_content?('이체구분 입력 테스트'))
    assert(page.has_content?('처리결과 입력 테스트'))
    assert(page.has_content?('거래메모 입력 테스트'))
    assert(page.has_content?('출금통장표시내용 입력 테스트'))
    assert(page.has_content?('입금통장표시내용 입력 테스트'))
    assert(page.has_content?('입금인성명 입력 테스트'))
  end

  test "should edit bank_transfer" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
    find("tr.selectable").click
    click_link '수정'

    fill_in "이체구분", with: "이체구분 수정 테스트"
    select('2012', :from => 'bank_transfer_transfered_at_1i')
    select('2월', :from => 'bank_transfer_transfered_at_2i')
    select('27', :from => 'bank_transfer_transfered_at_3i')
    select('12', :from => 'bank_transfer_transfered_at_4i')
    select('12', :from => 'bank_transfer_transfered_at_5i')
    fill_in "처리결과", with: "처리결과 수정 테스트"
    fill_in "출금계좌", with: "123-321-1234"
    fill_in "입금은행", with: "테스트 은행"
    fill_in "입금계좌", with: "321-123-4321"
    fill_in "수수료", with: "1000"
    fill_in "오류금액", with: "0"
    select('2012', :from => 'bank_transfer_registered_at_1i')
    select('2월', :from => 'bank_transfer_registered_at_2i')
    select('27', :from => 'bank_transfer_registered_at_3i')
    select('12', :from => 'bank_transfer_registered_at_4i')
    select('12', :from => 'bank_transfer_registered_at_5i')
    fill_in "오류코드", with: ""
    fill_in "거래메모", with: "거래메모 수정 테스트"
    fill_in "입금인코드", with: ""
    fill_in "출금통장표시내용", with: "출금통장표시내용 수정 테스트"
    fill_in "입금통장표시내용", with: "입금통장표시내용 수정 테스트"
    fill_in "입금인성명", with: "입금인성명 수정 테스트"
    fill_in "CMS코드", with: ""
    fill_in "통화 코드", with: ""

    click_button '이체 내역 수정하기'

    assert(page.has_content?('이체구분 수정 테스트'))
    assert(page.has_content?('처리결과 수정 테스트'))
    assert(page.has_content?('거래메모 수정 테스트'))
    assert(page.has_content?('출금통장표시내용 수정 테스트'))
    assert(page.has_content?('입금통장표시내용 수정 테스트'))
    assert(page.has_content?('입금인성명 수정 테스트'))
  end

  test "should destroy bank_transfer" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'

    find("tr.selectable").click

    disable_confirm_box

    click_link '삭제'

    assert(page.has_content?('외부 내용'))
    assert(page.has_content?('임의 내용'))
    assert(!page.has_content?('적금 만기'))
  end

  test "should create/show expense_report" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'

    find("tr.selectable").click

    click_link '지출내역서 만들기'

    fill_in "내역", with: "지출내역서 내역 입력 테스트"

    click_button '지출 내역서 만들기'

    assert(page.has_content?('지출내역서 내역 입력 테스트'))

    click_link '이체 내역 보기'
    click_link '지출내역서 보기'

    assert(page.has_content?('지출내역서 상세정보'))
  end

  test "should upload an excel file" do
    BankTransfer.destroy_all

    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
   
    click_link '엑셀 파일로 올리기'
    path = File.join(::Rails.root, "test/fixtures/excels/bank_transfer_fixture.xls") 
    attach_file("upload_file", path)

    click_button '미리보기'
    click_button '엑셀 파일'

    assert(page.has_content?('321-123-123456'))
    assert(page.has_content?('기업은행'))
    assert(page.has_content?('28505013648'))
  end

  test "should search transfer data" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'

    find_field('query').set("매니저")
    find_field('query').native.send_key(:enter)

    assert(page.has_content?('매니저'))
    assert(!page.has_content?('임의 내용'))
    assert(!page.has_content?('적금 만기'))

    find_field('query').set("임의 내용")
    find_field('query').native.send_key(:enter)

    assert(!page.has_content?('매니저'))
    assert(page.has_content?('임의 내용'))
    assert(!page.has_content?('적금 만기'))

    find_field('query').set("적금 만기")
    find_field('query').native.send_key(:enter)

    assert(!page.has_content?('매니저'))
    assert(!page.has_content?('임의 내용'))
    assert(page.has_content?('적금 만기'))
  end
end