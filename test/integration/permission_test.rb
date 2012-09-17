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
    find('.item1').click_link('출퇴근 관리')
    
    assert(page.has_content?('사용자 & 그룹 추가'))
  end

  test 'should add people_permission in show' do
    visit '/'
    click_link '권한 관리'
    find('.item1').click_link('출퇴근 관리')

    select '[개인] 김 개똥(normal)', from: 'participant'
    click_button "추가"

    assert(page.has_content?('성공적으로 사용자를 등록했습니다.'))
    assert(page.has_content?('김 개똥(normal)'))

    select '[개인] 김 개똥(normal)', from: 'participant'
    click_button "추가"

    assert(page.has_content?('이미 등록된 사용자입니다.'))

    normal_user_access

    visit '/'
    click_link '출퇴근 관리'

    assert(page.has_content?('출퇴근 기록 관리'))
    assert(page.has_content?('출퇴근 기록 목록'))
  end

  test 'should add group_permission in show' do
    visit '/'
    click_link '권한 관리'
    find('.item1').click_link('출퇴근 관리')

    select '[그룹] no_admin', from: 'participant'
    click_button "추가"

    assert(page.has_content?('성공적으로 사용자를 등록했습니다.'))
    assert(page.has_content?('no_admin'))

    project_admin_access

    visit '/'
    click_link '출퇴근 관리'

    assert(page.has_content?('출퇴근 기록 관리'))
    assert(page.has_content?('출퇴근 기록 목록'))
  end

  test 'should destroy uesr_permission' do
    visit '/'
    click_link '권한 관리'
    find('.item1').click_link('출퇴근 관리')

    select '[개인] 김 개똥(normal)', from: 'participant'
    click_button "추가"
    
    find('#content li[2]').click_link('[X]')
    
    normal_user_access

    visit '/'

    assert(!page.has_content?('출퇴근 관리'))
  end

  test 'should destroy group_permission' do
    visit '/'
    click_link '권한 관리'
    find('.item1').click_link('출퇴근 관리')

    select '[그룹] no_admin', from: 'participant'
    click_button "추가"
    
    click_link '[X]'
    click_link '[X]'

    select '[개인] 김 개똥(normal)', from: 'participant'
    click_button "추가"
    
    project_admin_access

    visit '/'

    assert(!page.has_content?('출퇴근 관리'))
  end
end