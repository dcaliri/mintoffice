# encoding: UTF-8
require 'test_helper'

class NUCardBillTest < ActionDispatch::IntegrationTest
  fixtures :cardbills
  fixtures :creditcards
  fixtures :access_people
  fixtures :card_used_sources
  fixtures :card_approved_sources
  fixtures :projects
  fixtures :project_assign_infos

  class ::ReportMailer
    def self.report(target, from, to, subject, message)
    end
  end 

  test 'should visit cardbill list' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'

    assert(page.has_content?('카드영수증 관리'))
    assert(page.has_content?('Total: 1'))
  end

  test 'should show cardbill' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    assert(page.has_content?('GS25'))
    assert(page.has_content?('6,000'))
    assert(page.has_content?('5,800'))
    assert(page.has_content?('200'))
    assert(page.has_content?('sk트윈타워 A동'))
  end

  test 'should edit cardbill' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '수정하기'

    fill_in "가맹점", with: "수정된 가맹점"
    fill_in "가맹점 주소", with: "수정된 가맹점 주소"

    click_button '카드 영수증 수정하기'

    assert(page.has_content?('수정된 가맹점'))
    assert(page.has_content?('수정된 가맹점 주소'))
  end

  test 'should create/show expense_reports' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    assert(page.has_content?('내역 입력 테스트'))

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '테스트 프로젝트'

    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should report admin' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')

    click_button '카드영수증 생성'

    normal_user_access

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    select '김 관리', from: 'reporter'
    fill_in "코멘트", with: "연차 사용 신청"

    click_button '상신'

    assert(page.has_content?('상태 - 결재 대기 중'))
  end
end