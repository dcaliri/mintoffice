# encoding: UTF-8
require 'test_helper'

class NUExpenseReportTest < ActionDispatch::IntegrationTest
  fixtures :expense_reports
  fixtures :postings
  fixtures :ledger_accounts
  fixtures :creditcards
  fixtures :card_histories
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :cardbills
  fixtures :bank_accounts
  fixtures :bank_transfers
  fixtures :access_people

  class ::ReportMailer
    def self.report(target, from, to, subject, message)
    end
  end

  test 'should visit expense list' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드 사용내역'
    click_link '카드영수증이 없는 목록 보기'
    click_link '신용카드 영수증 생성'

    select('[개인] 김 개똥', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    visit '/'
    click_link '지출내역서 관리'

    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should show expense' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드 사용내역'
    click_link '카드영수증이 없는 목록 보기'
    click_link '신용카드 영수증 생성'

    select('[개인] 김 개똥', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'

    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should report admin' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드 사용내역'
    click_link '카드영수증이 없는 목록 보기'
    click_link '신용카드 영수증 생성'

    select('[개인] 김 개똥', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'

    select '김 관리', from: 'reporter'
    fill_in "코멘트", with: "연차 사용 신청"

    click_button '상신'

    assert(page.has_content?('상태 - 결재 대기 중'))
  end

  test 'should edit expense_report' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드 사용내역'
    click_link '카드영수증이 없는 목록 보기'
    click_link '신용카드 영수증 생성'

    select('[개인] 김 개똥', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    visit '/'
    click_link '지출내역서 관리'
    click_link '상세보기'

    click_link '수정'

    fill_in "내역", with: "지출내역서 내역 수정 테스트"

    click_button '지출 내역서 수정하기'

    assert(page.has_content?('지출내역서 내역 수정 테스트'))
  end

  test 'should destroy expense_report' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드 사용내역'
    click_link '카드영수증이 없는 목록 보기'
    click_link '신용카드 영수증 생성'

    select('[개인] 김 개똥', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    visit '/'
    click_link '지출내역서 관리'
    select "전체"

    click_link '상세보기'

    disable_confirm_box

    click_link '삭제'

    assert(!page.has_content?('이체 내역'))
  end
end