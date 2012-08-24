# encoding: UTF-8
require 'test_helper'

class PermissionTest < ActionDispatch::IntegrationTest

  test 'should visit permission list' do
    visit '/'
    click_link '권한 관리'

    assert(page.has_content?('권한 관리'))
  end

  test 'should show permission' do
    visit '/'
    click_link '권한 관리'
    click_link 'Show'

    assert(page.has_content?('Add User:'))
  end

  test 'should add people_permission in show' do
    visit '/'
    click_link '권한 관리'
    click_link 'Show'

    fill_in "accountname", with: "normal"
    click_button "추가"

    assert(page.has_content?('성공적으로 사용자를 등록했습니다.'))
    assert(page.has_content?('normal'))
  end

  test 'should edit people_permission in show' do
    visit '/'
    click_link '권한 관리'
    click_link 'Show'
    click_link 'Edit'

    find(:css, "#permission_person_ids_[value='2']").set(true)

    click_button 'Update'

    assert(page.has_content?('권한이(가) 성공적으로 업데이트 되었습니다.'))

  end

  test 'should create a new permission' do
    visit '/'
    click_link '권한 관리'
    click_link 'New permission'

    fill_in "Name", with: "test"

    click_button 'Create'

    assert(page.has_content?('권한이(가) 성공적으로 생성되었습니다.'))

  end

  test 'should edit permission' do
    visit '/'
    click_link '권한 관리'
    click_link 'Edit'

    fill_in "Name", with: "test 수정"

    find(:css, "#permission_person_ids_[value='1']").set(true)
    find(:css, "#permission_person_ids_[value='2']").set(true)

    click_button 'Update'

    assert(page.has_content?('권한이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should destroy page' do
    visit '/'
    click_link '권한 관리'

    disable_confirm_box

    click_link 'Destroy'

    assert(page.has_content?('권한이(가) 성공적으로 제거 되었습니다.'))
  end
end