# encoding: UTF-8
require 'test_helper'

class ExpenseReportTest < ActionDispatch::IntegrationTest
  fixtures :expense_reports
  fixtures :postings
  fixtures :ledger_accounts
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :cardbills
  fixtures :bank_accounts
  fixtures :bank_transfers
  fixtures :access_people


  test 'should visit expense list' do
    visit '/'
    click_link '지출내역서 관리'

    assert(page.has_content?('지출내역서'))
  end

  test 'should show expense' do
    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'

    assert(page.has_content?('지출내역서 상세정보'))
  end

  test 'should edit expense' do
    visit '/'

    click_link '지출내역서 관리'
    click_link '상세보기'

    click_link '수정'

    fill_in "내역", with: "지출내역서 내역 수정 테스트"

    click_button '지출 내역서 수정하기'

    assert(page.has_content?('지출내역서 내역 수정 테스트'))
  end

  test 'should add expense tag' do
    visit '/'

    click_link '지출내역서 관리'
    click_link '상세보기'

    click_link '수정'

    fill_in '태그명', with: 'test tag'
    click_button '추가하기'

    assert(page.has_content?('test tag'))

    fill_in '태그명', with: 'test tag'
    click_button '추가하기'

    assert(page.has_content?('Already exists'))

    click_link '삭제하기'

    assert(!page.has_content?('test tag'))

    fill_in '태그명', with: 'test tag'
    click_button '추가하기'

    click_link '돌아가기'
    click_link '상세보기'

    assert(page.has_content?('test tag'))
  end

  test 'should destroy expense' do
    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제'

    assert(!page.has_content?('이체 내역'))
  end

  test 'should show cardbill' do
    visit '/'
    click_link '지출내역서 관리'
    visit '/expenses/1'
    click_link '이체 내역 보기'

    assert(page.has_content?('타행이체'))
    assert(page.has_content?('신한은행'))
    assert(page.has_content?('28505013648'))
  end

  test 'should show transfer' do
    visit '/'
    click_link '지출내역서 관리'
    visit '/expenses/2'
    click_link '카드 영수증 보기'

    assert(page.has_content?('5,800'))
    assert(page.has_content?('6,000'))
    assert(page.has_content?('버터플라이'))
  end

  test 'should approve expense and create postings' do
    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'
    
    click_button '승인'
    click_link '전표 만들기'

    fill_in "상세정보", with: "전표 만들기 상세정보 입력 테스트"
    click_button '전표 만들기'

    assert(page.has_content?('전표 만들기 상세정보 입력 테스트'))
  end
end