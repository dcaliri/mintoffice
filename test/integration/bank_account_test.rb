# encoding: UTF-8
require 'test_helper'

class BankAccountTest < ActionDispatch::IntegrationTest
  fixtures :bank_accounts
  fixtures :bank_transactions
  fixtures :bank_transfers
  fixtures :groups
  fixtures :groups_users

  test 'should visit document list' do
    visit '/'
    click_link '은행계좌 목록'

    assert(page.has_content?('은행계좌 관리'))
  end

  test 'should visit the document' do
    visit '/'
    click_link '은행계좌 목록'
    find("tr.selectable").click

    assert(page.has_content?('신한 은행'))
    assert(page.has_content?('321-123-123456'))
    assert(page.has_content?('주요 은행 계좌'))
  end

  test 'should create a new document' do
    visit '/'
    click_link '은행계좌 목록'
    click_link '은행계좌 만들기'

    fill_in "계정", with: "개인 은행계좌"
    fill_in "설명", with: "개인 은행계좌입니다."

    click_button "은행계좌 만들기"

    assert(page.has_content?('개인 은행계좌'))
    assert(page.has_content?('개인 은행계좌입니다.'))
  end

  test 'should edit the exist document' do
    visit '/'
    click_link '은행계좌 목록'
    find("tr.selectable").click
    click_link '수정'

    fill_in "계정", with: "수정된 은행계좌"
    fill_in "설명", with: "수정된 은행계좌입니다."

    click_button "은행계좌 수정하기"

    assert(page.has_content?('수정된 은행계좌'))
    assert(page.has_content?('수정된 은행계좌입니다.'))
  end

  test "should destroy the document" do
    visit '/'
    click_link '은행계좌 목록'
    find("tr.selectable").click
    
    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(!page.has_content?('신한 은행'))
  end

  test "should show total" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '합계표 보기'
    
    assert(page.has_content?('입출금 합계표'))
  end

  test "should show bank_transactions" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '입출금내역 보기'
    
    assert(page.has_content?('입출금 내역'))
  end

  test "should show bank_transfers" do
    visit '/'
    click_link '은행계좌 목록'
    click_link '이체내역 보기'
    
    assert(page.has_content?('이체 내역'))
  end

  test "should show bank_transactions in document" do
    visit '/'
    click_link '은행계좌 목록'
    find("tr.selectable").click

    click_link '입출금 내역'

    assert(page.has_content?('입출금 내역'))
    assert(page.has_content?('신한 은행 : 321-123-123456'))
  end  

  test "should show bank_transfers in document" do
    visit '/'
    click_link '은행계좌 목록'
    find("tr.selectable").click

    click_link '이체 내역'

    assert(page.has_content?('이체 내역'))
    assert(page.has_content?('신한 은행 : 321-123-123456'))
  end  
end