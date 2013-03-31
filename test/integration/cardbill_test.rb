# encoding: UTF-8
require 'test_helper'

class CardBillTest < ActionDispatch::IntegrationTest
  fixtures :cardbills
  fixtures :creditcards
  fixtures :access_people
  fixtures :card_histories
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments

  test 'should visit cardbill list' do
    visit '/'
    click_link '카드 영수증 목록'

    assert(page.has_content?('카드영수증 관리'))
    assert(page.has_content?('Total: 3'))
  end

  test 'should show has_permission_cardbills' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    assert(page.has_content?('카드 영수증 내역'))
  end

  test 'should show has_not_permission_cardbills' do
    switch_to_selenium

    visit '/'
    click_link '회계관리'
    click_link '카드 영수증 목록'
    select('권한을 알 수 없는 내역 보기', :from => 'empty_permission')
    assert(page.has_content?('Total: 1'))

    click_link '상세보기'

    assert(page.has_content?('카드 영수증 내역'))
  end

  test 'should create/show expense_reports' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '지출내역서 만들기'

    fill_in "내역", with: "내역 입력 테스트"

    click_button '지출 내역서 만들기'

    assert(page.has_content?('내역 입력 테스트'))

    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '테스트 프로젝트'

    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should show card history' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '사용내역 보기'

    assert(page.has_content?('카드 사용내역 정보'))
  end

  test 'should edit cardbill' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '수정하기'

    fill_in "가맹점", with: "수정된 가맹점"

    click_button '카드 영수증 수정하기'

    assert(page.has_content?('수정된 가맹점'))
  end

  test 'should add permission and delete permission' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    select('쓰기', :from => 'access_type')
    select('김 개똥', :from => 'accessor')

    click_button '변경하기'

    assert(page.has_content?('성공적으로 권한을 설정하였습니다.'))

    click_link '[x]'

    assert(page.has_content?('성공적으로 권한을 제거하였습니다.'))
  end

  test 'should back cardbill list' do
    visit '/'
    click_link '카드 영수증 목록'
    click_link '상세보기'

    click_link '목록'

    assert(page.has_content?('카드영수증 관리'))
  end
end