# encoding: UTF-8
require 'test_helper'

class GroupTest < ActionDispatch::IntegrationTest

  test 'should visit group list' do
    visit '/'
    click_link '그룹관리'

    assert(page.has_content?('no_admin'))
    assert(page.has_content?('another'))
  end

  test 'should show group_people' do
    visit '/'
    click_link '그룹관리'
    click_link '상세보기'

    assert(page.has_content?('부모'))
    assert(page.has_content?('서브그룹'))
    assert(page.has_content?('no_admin'))
    assert(page.has_content?('another'))
    assert(page.has_content?('소속 맴버'))
    assert(page.has_content?('김 관리(admin) - admin'))
    assert(page.has_content?('김 개똥(normal) - no_admin'))
    assert(page.has_content?('카드영수증 매니저(card_manager) - no_admin'))
    assert(page.has_content?('카드 사용자(card_user) - no_admin'))
  end

  test 'should create a new group' do
    visit '/'
    click_link '그룹관리'
    click_link '신규 작성'
    
    assert(!page.has_content?('김 관리김 관리(admin)'))

    fill_in "그룹명", with: "그룹명 입력 테스트"
    select 'admin', from: 'group_parent_id'
    find(:css, "#group_person_ids_[value='1']").set(true)

    click_button 'Group 만들기'

    visit '/groups/4'

    assert(page.has_content?('그룹명 입력 테스트'))
    assert(page.has_content?('김 관리(admin)'))
    assert(!page.has_content?('김 관리김 관리(admin)'))
  end

  test 'should create a new group without parent_group' do
    visit '/'
    click_link '그룹관리'
    click_link '신규 작성'

    fill_in "그룹명", with: "그룹명 입력 테스트"
    select '없음', from: 'group_parent_id'
    find(:css, "#group_person_ids_[value='1']").set(true)

    click_button 'Group 만들기'

    visit '/groups/4'

    assert(page.has_content?('그룹명 입력 테스트'))
    assert(page.has_content?('김 관리(admin)'))
  end

  test 'should edit group' do
    visit '/'
    click_link '그룹관리'
    visit '/groups/2'
    click_link '수정하기'

    assert(page.has_content?("사원 선택"))
    assert(!page.has_content?("Employee"))

    fill_in "그룹명", with: "그룹명 수정 테스트"
    select 'another', from: 'group_parent_id'
    find(:css, "#group_person_ids_[value='1']").set(true)

    click_button 'Group 수정하기'

    assert(page.has_content?("그룹명 수정 테스트"))
    assert(page.has_content?("another"))
    assert(page.has_content?("김 관리(admin)"))
    assert(page.has_content?("김 개똥(normal)"))
  end

  test 'should not show retired_user in new' do
    visit '/'
    click_link '그룹관리'
    click_link '신규 작성'

    assert(page.has_content?('김 개똥(normal)'))
    assert(page.has_content?('카드영수증 매니저(card_manager)'))
    assert(page.has_content?('카드 사용자(card_user)'))
    assert(!page.has_content?('퇴 직자(retired_user)'))
  end

  test 'should not show retired_user in edit' do
    visit '/'
    click_link '그룹관리'
    click_link '상세보기'
    click_link '수정하기'

    assert(page.has_content?('김 개똥(normal)'))
    assert(page.has_content?('카드영수증 매니저(card_manager)'))
    assert(page.has_content?('카드 사용자(card_user)'))
    assert(!page.has_content?('퇴 직자(retired_user)'))
  end

  test 'should click group and subgroup link' do
    visit '/'
    click_link '그룹관리'
    click_link '상세보기'

    find('#content').click_link('no_admin')

    assert(page.has_content?('김 개똥(normal)'))
    assert(page.has_content?('카드영수증 매니저(card_manager)'))
    assert(page.has_content?('카드 사용자(card_user)'))

    click_link 'admin'

    assert(find('#content').has_content?("김 관리(admin)"))
  end
end