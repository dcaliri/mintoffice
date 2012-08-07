# encoding: UTF-8
require 'test_helper'

class ProjectTest < ActionDispatch::IntegrationTest
  fixtures :projects

  test 'should visit poject list' do
    visit '/'
    click_link '프로젝트 관리'

    assert(page.has_content?('프로젝트 관리'))
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
    find("tr.selectable").click
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

  test 'should add/delete accounts' do
    visit '/'
    click_link '프로젝트 관리'
    find("tr.selectable").click

    click_link '수정하기'

    fill_in "계정명", with: "admin"
    click_button '추가하기'

    assert(page.has_content?('admin'))

    click_link '삭제하기'

    assert(!page.has_content?('삭제하기'))
  end

  test 'should complete project' do
    visit '/'
    click_link '프로젝트 관리'
    find("tr.selectable").click

    click_link '수정하기'
    click_link '프로젝트 완료'
    page.driver.browser.switch_to.alert.accept

    click_link '프로젝트 관리 - 완료'

    assert(page.has_content?('테스트 프로젝트'))
  end  

  test 'should back project' do
    visit '/'
    click_link '프로젝트 관리'
    find("tr.selectable").click

    click_link '수정하기'
    click_link '내용 보기'
    
    assert(page.has_content?('테스트 프로젝트'))
  end  

  test 'should back project list' do
    visit '/'
    click_link '프로젝트 관리'
    find("tr.selectable").click

    click_link '수정하기'
    click_link '돌아가기'
    
    assert(page.has_content?('프로젝트 관리 - 진행중'))
  end  
end