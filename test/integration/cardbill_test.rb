# encoding: UTF-8
require 'test_helper'

class CardBillTest < ActionDispatch::IntegrationTest
  fixtures :cardbills
  fixtures :creditcards
  fixtures :access_people
  fixtures :card_used_sources
  fixtures :card_approved_sources
  fixtures :projects
  fixtures :project_assign_infos

  test 'should visit cardbill list' do
    visit '/'
    click_link '카드 영수증 목록'

    assert(page.has_content?('카드영수증 관리'))
    assert(page.has_content?('Total: 3'))
  end

  test 'should show has_permission_cardbills' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    assert(page.has_content?('카드 영수증 내역'))
  end

  test 'should show has_not_permission_cardbills' do
    visit '/'
    click_link '카드 영수증 목록'
    select('권한을 알 수 없는 내역 보기', :from => 'empty_permission')

    assert(page.has_content?('Total: 1'))

    find("tr.selectable").click

    assert(page.has_content?('카드 영수증 내역'))
  end

  test 'should show used_sources' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '사용 내역'

    assert(page.has_content?('신용카드 이용내역'))
  end

  test 'should create/show expense_reports' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '지출내역서 만들기'

    fill_in "내역", with: "카드 영수증 지출내역서"

    click_button '지출 내역서 만들기'

    assert(page.has_content?('카드 영수증 지출내역서'))

    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '테스트 프로젝트'

    assert(page.has_content?('테스트 프로젝트'))
    assert(page.has_content?('카드 영수증 지출내역서'))
  end

  test 'should show approved_sources' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '승인내역'

    assert(page.has_content?('카드승인내역'))
  end

  test 'should edit cardbill' do
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

  test 'should add permission and delete permission' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    select('쓰기', :from => 'access_type')
    select('no employee', :from => 'accessor')

    click_button 'Save changes'

    assert(page.has_content?('성공적으로 권한을 설정하였습니다.'))

    click_link '[x]'

    assert(page.has_content?('성공적으로 권한을 제거하였습니다.'))
  end

  test 'should back cardbill list' do
    visit '/'
    click_link '카드 영수증 목록'
    find("tr.selectable").click

    click_link '목록'

    assert(page.has_content?('카드영수증 관리'))
  end
end