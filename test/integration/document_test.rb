# encoding: UTF-8
require 'test_helper'

class DocumentTest < ActionDispatch::IntegrationTest
  fixtures :documents
  fixtures :document_owners
  fixtures :documents_tags
  fixtures :projects
  fixtures :project_assign_infos
  fixtures :tags
  fixtures :taggings
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :access_people

  test 'should visit document list' do
    visit '/'
    click_link '문서 관리'

    assert(page.has_content?('문서 관리'))
    assert(!page.has_content?('소유자'))
  end

  test 'should show document' do
    visit '/'
    click_link '문서 관리'
    click_link '상세보기'

    assert(!page.has_content?('소유자'))
    assert(page.has_content?('테스트 문서'))
    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should create a new document' do
    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    assert(!page.has_content?('소유자'))
    assert(!page.has_content?('참여자 없는 프로젝트'))
    assert(!page.has_content?('완료된 프로젝트'))
    assert(page.has_content?('테스트 프로젝트'))

    select '테스트 프로젝트', from: 'document_project_id'
    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    assert(page.has_content?('문서이(가) 성공적으로 생성되었습니다.'))
    assert(page.has_content?('문서제목 입력 테스트'))
    assert(page.has_content?('테스트 프로젝트'))
  end

  test 'should edit document' do
    visit '/'
    click_link '문서 관리'
    select('전체', :from => 'report_status')
    click_link '상세보기'

    click_link '수정하기'

    assert(!page.has_content?('소유자'))
    assert(!page.has_content?('참여자 없는 프로젝트'))
    assert(!page.has_content?('완료된 프로젝트'))
    assert(page.has_content?('테스트 프로젝트'))

    select '테스트 프로젝트', from: 'document_project_id'
    fill_in "문서제목", with: "문서제목 수정 테스트"

    click_button '갱신하기'

    assert(page.has_content?('문서이(가) 성공적으로 업데이트 되었습니다.'))
    assert(page.has_content?('문서제목 수정 테스트'))
  end

  test 'should destroy document' do
    visit '/'
    click_link '문서 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('테스트 문서'))
  end

  test 'should create tags' do
    visit '/'
    click_link '문서 관리'
    click_link '상세보기'

    click_link '수정하기'
    fill_in "태그명", with: "태그명 입력 테스트"
    find_by_id("new_tag").find_button("추가하기").click
    assert(page.has_content?('태그명 입력 테스트'))
  end

  test 'should destroy tags' do
    visit '/'
    click_link '문서 관리'
    click_link '상세보기'

    click_link '수정하기'
    fill_in "태그명", with: "테그명 입력 테스트"
    find_by_id("new_tag").find_button("추가하기").click
    find(".tag-list").find_link("삭제하기").click
    assert(!page.has_content?('태그명 입력 테스트'))
  end

  test 'should approve/rollback' do
    visit '/'
    click_link '문서 관리'
    click_link '상세보기'

    fill_in "코멘트", with: "승인 테스트"
    click_button '승인'

    assert(page.has_content?('김 관리(admin): 승인 테스트'))
    assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 승인하였습니다.'))

    fill_in "코멘트", with: "반려 테스트"
    click_button '반려'

    assert(page.has_content?('김 관리(admin): 반려 테스트'))
    assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 반려하였습니다.'))
  end

  test 'create documents and check them' do
    Document.destroy_all

    visit '/'
    click_link '문서 관리'

    (1..40).each do |i|
      click_link '새로운 문서 작성'

      select "테스트 프로젝트", from: 'document_project_id'
      fill_in "문서제목", with: "테스트 문서#{i}"

      click_button '만들기'

      click_link '목록'
    end

    select '전체', from: 'report_status'
    fill_in "query", with: "테스트 문서"
    click_button "검색"

    assert(page.has_content?('총합: 40'))

    click_link '1'
    
    (21..40).each do |i|
      assert(page.has_content?("테스트 문서#{i}"))
    end
    assert(!page.has_content?("테스트 문서20"))

    click_link '2'
    
    (1..20).each do |i|
      assert(page.has_content?("테스트 문서#{i}"))
    end
    assert(!page.has_content?("테스트 문서21"))
  end

  test 'group member should view document' do
    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    select "테스트 프로젝트", from: 'document_project_id'
    fill_in "문서제목", with: "no_admin 문서"

    click_button '만들기'

    select '[그룹] no_admin', from: 'accessor'

    click_button 'Save changes'

    normal_user_access

    visit '/'
    click_link '문서 관리'

    select '전체', from: 'report_status'
    fill_in "query", with: "no_admin 문서"
    click_button "검색"

    click_link '상세보기'

    assert(page.has_content?("no_admin 문서"))

    project_admin_access

    visit '/'
    click_link '문서 관리'

    select '전체', from: 'report_status'
    fill_in "query", with: "no_admin 문서"
    click_button "검색"

    click_link '상세보기'

    assert(page.has_content?("no_admin 문서"))
  end
end