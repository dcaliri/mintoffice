# encoding: UTF-8
require 'test_helper'

class GroupTest < ActionDispatch::IntegrationTest

  test 'should visit group list' do
    visit '/'
    click_link '그룹관리'

    assert(page.has_content?('no_admin'))
  end

  test 'should show group_people' do
    visit '/'
    click_link '그룹관리'
    find("tr.selectable").click

    assert(page.has_content?('내용 보기'))
  end

  test 'should create a new group' do
    visit '/'
    click_link '그룹관리'
    click_link '신규 작성'

    fill_in "그룹명", with: "그룹명 입력 테스트"

    check('group_person_ids_')

    click_button 'Group 만들기'

    assert(page.has_content?('그룹명 입력 테스트'))
  end

  test 'should edit group' do
    visit '/'
    click_link '그룹관리'
    visit '/groups/2'
    click_link '수정하기'

    fill_in "그룹명", with: "그룹명 수정 테스트"

    click_button 'Group 수정하기'

    assert(page.has_content?("그룹명 수정 테스트"))
  end
end