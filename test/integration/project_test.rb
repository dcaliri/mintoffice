# encoding: UTF-8
require 'test_helper'

class ProjectTest < ActionDispatch::IntegrationTest
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :project_assign_rates

  test 'admin should show poject' do
    visit '/'
    click_link '프로젝트 관리'

    assert(page.has_content?('테스트 프로젝트'))
    assert(page.has_content?('2,000,000'))
    assert(page.has_content?('참여자 없는 프로젝트'))

    click_link '상세보기'

    assert(page.has_content?('2,000,000'))
    assert(page.has_content?('지출내역'))
  end

  test 'normal should show poject' do
    normal_user_access

    visit '/'
    click_link '프로젝트 관리'

    assert(page.has_content?('테스트 프로젝트'))
    assert(!page.has_content?('2,000,000'))
    assert(!page.has_content?('참여자 없는 프로젝트'))

    click_link '상세보기'

    assert(!page.has_content?('2,000,000'))
    assert(!page.has_content?('내역 금액'))
  end

  test 'project admin should show poject' do
    project_admin_access

    visit '/'
    click_link '프로젝트 관리'
    
    assert(page.has_content?('테스트 프로젝트'))
    assert(page.has_content?('2,000,000'))
    assert(!page.has_content?('참여자 없는 프로젝트'))

    click_link '상세보기'

    assert(page.has_content?('2,000,000'))
    assert(page.has_content?('지출내역'))
  end

  test 'should create new project' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '새 프로젝트 작성'

    fill_in "프로젝트명", with: "프로젝트명 입력 테스트"
    select('2012', :from => 'project_started_on_1i')
    select('5월', :from => 'project_started_on_2i')
    select('15', :from => 'project_started_on_3i')
    select('2012', :from => 'project_ending_on_1i')
    select('7월', :from => 'project_ending_on_2i')
    select('20', :from => 'project_ending_on_3i')
    fill_in "계약금액", with: "1000000"

    click_button '만들기'

    assert(page.has_content?('프로젝트이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('프로젝트명 입력 테스트'))
    assert(page.has_content?('1,000,000'))
  end

  test 'should edit project' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "프로젝트명", with: "프로젝트명 수정 테스트"
    select('2012', :from => 'project_started_on_1i')
    select('1월', :from => 'project_started_on_2i')
    select('12', :from => 'project_started_on_3i')
    select('2012', :from => 'project_ending_on_1i')
    select('8월', :from => 'project_ending_on_2i')
    select('21', :from => 'project_ending_on_3i')
    fill_in "계약금액", with: "2000000"

    click_button '갱신하기'

    assert(page.has_content?('프로젝트이(가) 성공적으로 업데이트 되었습니다.'))

    assert(page.has_content?('프로젝트명 수정 테스트'))
    assert(page.has_content?('2,000,000'))
  end  

  test 'should add/delete employee accounts and assign manager' do
    ProjectAssignInfo.destroy_all

    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'
    click_link '수정하기'

    select '사용자', from: 'participant_type'
    fill_in "계정명", with: "admin"
    click_button '추가하기'

    click_link '돌아가기'

    click_link '상세보기'

    assert(page.has_content?('없음'))
    assert(page.has_content?('[사용자] 김 관리(admin)'))

    click_link '수정하기'

    select '사용자', from: 'participant_type'
    fill_in "계정명", with: "normal"
    click_button '추가하기'

    assert(page.has_content?('[사용자] 김 개똥(normal)'))

    click_link '(관리자 변경하기)'

    assert(page.has_content?('[사용자] 김 관리(admin) -프로젝트 관리자-'))

    click_link '내용 보기'

    assert(!page.has_content?('없음'))
    assert(page.has_content?('[사용자] 김 관리(admin)'))
    assert(page.has_content?('[사용자] 김 개똥(normal)'))

    click_link '수정하기'
    click_link '삭제하기'

    assert(!page.has_content?('[사용자] 김 관리(admin) -프로젝트 관리자-'))

    click_link '내용 보기'

    assert(page.has_content?('없음'))
    assert(page.has_content?('[사용자] 김 개똥(normal)'))

    normal_user_access

    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    assert(page.has_content?('없음'))
    assert(page.has_content?('[사용자] 김 개똥(normal)'))
  end

  test 'should add/delete group accounts and assign manager' do
    ProjectAssignInfo.destroy_all

    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'
    click_link '수정하기'

    select '그룹', from: 'participant_type'
    fill_in "계정명", with: "no_admin"
    click_button '추가하기'

    click_link '내용 보기'

    assert(page.has_content?('없음'))
    assert(page.has_content?('[그룹] no_admin'))

    normal_user_access

    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    assert(page.has_content?('없음'))
    assert(page.has_content?('[그룹] no_admin'))
  end


  test 'should complete project' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    click_link '수정하기'
    click_link '프로젝트 완료'

    assert(!page.has_content?('테스트 프로젝트'))
    assert(page.has_content?('참여자 없는 프로젝트'))
    
    click_link '프로젝트 관리 - 완료'

    assert(page.has_content?('테스트 프로젝트'))
    assert(page.has_content?('완료된 프로젝트'))
  end

  test 'should show project assign rate' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    click_link '수정하기'

    fill_in "계정명", with: "admin"
    click_button '추가하기'
    
    click_link '프로젝트 완료'
    
    click_link '프로젝트 관리 - 완료'

    click_link '상세보기'
    click_link '할당비율 조정'

    assert(page.has_content?('할당 비율 조정'))
  end  

  test 'should back project' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    click_link '수정하기'
    click_link '내용 보기'
    
    assert(page.has_content?('테스트 프로젝트'))
  end  

  test 'should back project list' do
    visit '/'
    click_link '프로젝트 관리'
    click_link '상세보기'

    click_link '수정하기'
    click_link '돌아가기'
    
    assert(page.has_content?('프로젝트 관리 - 진행중'))
  end

  test 'nomal can not access project that not assign to me' do
    normal_user_access
    
    visit '/projects/2'

    assert(page.has_content?("You don't have to permission"))
  end
end