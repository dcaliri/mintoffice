# encoding: UTF-8
require 'test_helper'

class PostingTest < ActionDispatch::IntegrationTest
  fixtures :postings
  fixtures :posting_items
  fixtures :ledger_accounts
  fixtures :expense_reports

  test 'should visit posting list' do
    visit '/'
    click_link '전표 관리'
    
    assert(page.has_content?('전표 관리'))
  end

  test 'should create posting' do
    visit '/'
    click_link '전표 관리'
    click_link '신규 작성'

    fill_in "상세정보", with: "상세정보 입력 테스트"
    find_by_id("debit-form").fill_in("금액", with: "1000")
    find_by_id("credit-form").fill_in("금액", with: "1000")

    click_button '전표 만들기'

    assert(page.has_content?('상세정보 입력 테스트'))
  end

  test 'should edit posting' do
    visit '/'
    click_link '전표 관리'
    click_link '상세보기'

    click_link '수정하기'

    fill_in "상세정보", with: "상세정보 수정 테스트"
    find_by_id("debit-form").fill_in("금액", with: "1000")
    find_by_id("credit-form").fill_in("금액", with: "1000")

    click_button '전표 수정하기'

    assert(page.has_content?('상세정보 수정 테스트'))
  end

  test 'should destroy posting' do
    visit '/'
    click_link '전표 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('상세내용 기입 테스트'))
  end

end