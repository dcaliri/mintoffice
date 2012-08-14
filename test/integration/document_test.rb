# encoding: UTF-8
require 'test_helper'

class DocumentTest < ActionDispatch::IntegrationTest
  fixtures :documents
  fixtures :document_owners
  fixtures :documents_tags
  fixtures :projects
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
  end

  test 'should create a new document' do
    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    assert(page.has_content?('문서이(가) 성공적으로 생성되었습니다.'))
  end

  test 'should edit document' do
    visit '/'
    click_link '문서 관리'
    select('전체', :from => 'report_status')
    find("tr.selectable").click

    click_link '수정하기'

    fill_in "문서제목", with: "문서제목 수정 테스트"

    click_button '갱신하기'

    assert(page.has_content?('문서이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should destroy document' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('테스트 문서'))
  end

  test 'should add owners' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    click_link '수정하기'

    fill_in "사용자 추가", with: "normal"
    click_button '추가하기'

    assert(page.has_content?('김 개똥'))
  end

  test 'should delete owners' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    click_link '수정하기'
    click_link '삭제하기'

    assert(!page.has_content?('admin삭제하기'))
  end

  test 'should create tags' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    click_link '수정하기'
    fill_in "태그명", with: "태그명 입력 테스트"
    find_by_id("new_tag").find_button("추가하기").click
    assert(page.has_content?('태그명 입력 테스트'))
  end

  test 'should destroy tags' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    click_link '수정하기'
    fill_in "태그명", with: "테그명 입력 테스트"
    find_by_id("new_tag").find_button("추가하기").click
    find(".tag-list").find_link("삭제하기").click
    assert(!page.has_content?('태그명 입력 테스트'))
  end

  test 'should approve/rollback' do
    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    fill_in "코멘트", with: "승인 테스트"
    click_button '승인'

    assert(page.has_content?('admin: 승인 테스트'))
    assert(page.has_content?('admin: 왕 수용님이 결재를 승인하였습니다.'))

    fill_in "코멘트", with: "반려 테스트"
    click_button '반려'

    assert(page.has_content?('admin: 반려 테스트'))
    assert(page.has_content?('admin: 왕 수용님이 결재를 반려하였습니다.'))
  end
end