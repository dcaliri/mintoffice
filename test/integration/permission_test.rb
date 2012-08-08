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

    find_field('username').set("normal")
    find_field('username').native.send_key(:enter)

    assert(page.has_content?('성공적으로 사용자를 등록했습니다.'))
    assert(page.has_content?('normal'))
  end

  test 'should edit people_permission in show' do
    visit '/'
    click_link '권한 관리'
    click_link 'Show'
    click_link 'Edit'
    
    find(:css, "#permission_user_ids_[value='2']").set(true)

    click_button 'Update'

    assert(page.has_content?('Permission was successfully updated.'))
  end

  test 'should create a new permission' do
    visit '/'
    click_link '권한 관리'
    click_link 'New permission'

    fill_in "Name", with: "test"

    click_button 'Create'

    assert(page.has_content?('Permission was successfully created.'))
  end

  test 'should edit permission' do
    visit '/'
    click_link '권한 관리'
    click_link 'Edit'

    fill_in "Name", with: "test 수정"
    find(:css, "#permission_user_ids_[value='1']").set(true)
    find(:css, "#permission_user_ids_[value='2']").set(true)
    
    click_button 'Update'

    assert(page.has_content?('Permission was successfully updated.'))
  end

  test 'should destroy page' do
    visit '/'
    click_link '권한 관리'

    click_link 'Destroy'
    page.driver.browser.switch_to.alert.accept
    
    assert(!page.has_content?('accessors'))
  end
end