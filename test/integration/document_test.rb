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
  fixtures :business_clients
  fixtures :taxmen
  fixtures :contacts
  fixtures :contact_phone_numbers
  fixtures :contact_emails

  class ::ReportMailer
    def self.report(target, from, to, subject, message)
    end
  end 

  # test 'should visit document list' do
  #   visit '/'
  #   click_link '문서 관리'

  #   assert(page.has_content?('문서 관리'))
  #   assert(!page.has_content?('소유자'))
  # end

  # test 'should show document' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   assert(!page.has_content?('소유자'))
  #   assert(page.has_content?('테스트 문서'))
  #   assert(page.has_content?('테스트 프로젝트'))
  #   assert(page.has_content?('인사정보'))
  # end

  # test 'should create a new document' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   assert(!page.has_content?('소유자'))
  #   assert(!page.has_content?('참여자 없는 프로젝트'))
  #   assert(!page.has_content?('완료된 프로젝트'))
  #   assert(page.has_content?('테스트 프로젝트'))

  #   select '테스트 프로젝트', from: 'document_project_id'
  #   fill_in "문서제목", with: "문서제목 입력 테스트"

  #   click_button '만들기'

  #   assert(page.has_content?('문서이(가) 성공적으로 생성되었습니다.'))
  #   assert(page.has_content?('문서제목 입력 테스트'))
  #   assert(page.has_content?('테스트 프로젝트'))
  # end

  # test 'should edit document' do
  #   visit '/'
  #   click_link '문서 관리'
  #   select('전체', :from => 'report_status')
  #   click_link '상세보기'

  #   click_link '수정하기'

  #   assert(!page.has_content?('소유자'))
  #   assert(!page.has_content?('참여자 없는 프로젝트'))
  #   assert(!page.has_content?('완료된 프로젝트'))
  #   assert(page.has_content?('테스트 프로젝트'))

  #   select '테스트 프로젝트', from: 'document_project_id'
  #   fill_in "문서제목", with: "문서제목 수정 테스트"

  #   click_button '갱신하기'

  #   assert(page.has_content?('문서이(가) 성공적으로 업데이트 되었습니다.'))
  #   assert(page.has_content?('문서제목 수정 테스트'))
  # end

  # test 'should destroy document' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   disable_confirm_box

  #   click_link '삭제하기'

  #   assert(!page.has_content?('테스트 문서'))
  # end

  # test 'should create tags' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   click_link '수정하기'
  #   fill_in "태그명", with: "태그명 입력 테스트"
  #   find_by_id("new_tag").find_button("추가하기").click
  #   assert(page.has_content?('태그명 입력 테스트'))
  # end

  # test 'should destroy tags' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   click_link '수정하기'
  #   fill_in "태그명", with: "테그명 입력 테스트"
  #   find_by_id("new_tag").find_button("추가하기").click
  #   find(".tag-list").find_link("삭제하기").click
  #   assert(!page.has_content?('태그명 입력 테스트'))
  # end

  # test 'should approve/rollback' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   fill_in "코멘트", with: "승인 테스트"
  #   click_button '승인'

  #   assert(page.has_content?('김 관리(admin): 승인 테스트'))
  #   assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 승인하였습니다.'))

  #   fill_in "코멘트", with: "반려 테스트"
  #   click_button '반려'

  #   assert(page.has_content?('김 관리(admin): 반려 테스트'))
  #   assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 반려하였습니다.'))
  # end

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

  # test 'group member should view document' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   select "테스트 프로젝트", from: 'document_project_id'
  #   fill_in "문서제목", with: "no_admin 문서"

  #   click_button '만들기'

  #   select '[그룹] no_admin', from: 'accessor'

  #   click_button 'Save changes'

  #   normal_user_access

  #   visit '/'
  #   click_link '문서 관리'

  #   select '전체', from: 'report_status'
  #   fill_in "query", with: "no_admin 문서"
  #   click_button "검색"

  #   click_link '상세보기'

  #   assert(page.has_content?("no_admin 문서"))

  #   project_admin_access

  #   visit '/'
  #   click_link '문서 관리'

  #   select '전체', from: 'report_status'
  #   fill_in "query", with: "no_admin 문서"
  #   click_button "검색"

  #   click_link '상세보기'

  #   assert(page.has_content?("no_admin 문서"))
  # end

  # test 'should create a linked_taxbill' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   select "테스트 프로젝트", from: 'document_project_id'
  #   fill_in "문서제목", with: "세금 계산서 문서"

  #   click_button '만들기'

  #   assert(!page.has_content?('세금계산서 만들기'))
  #   assert(!find('#descr').has_content?('세금계산서'))

  #   fill_in '코멘트', with: '세금계산서 문서 상신'
  #   click_button '승인'

  #   click_link '세금계산서 만들기'

  #   select '김 관리 / 테스트 거래처', from: 'taxbill_taxman_id'

  #   click_button '세금계산서 만들기'

  #   assert(page.has_content?('거래처명 : 테스트 거래처 ( 123-321-1234 ) - MINT'))

  #   click_link '세금 계산서 문서'

  #   assert(page.has_content?('세금 계산서 문서'))
  #   assert(page.has_content?('테스트 프로젝트'))
  #   assert(page.has_content?('[개인] 김 관리(읽기/쓰기)'))

  #   assert(!page.has_content?('세금계산서 만들기'))
  #   assert(page.has_content?('세금계산서'))

  #   click_link '세금계산서'

  #   assert(page.has_content?('거래처명 : 테스트 거래처 ( 123-321-1234 ) - MINT'))
  # end

  # test 'normal should create a linked_taxbill' do
  #   Document.destroy_all
  #   Taxbill.destroy_all

  #   normal_user_access

  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   select "테스트 프로젝트", from: 'document_project_id'
  #   fill_in "문서제목", with: "세금 계산서 문서"

  #   click_button '만들기'

  #   assert(!page.has_content?('세금계산서 만들기'))

  #   fill_in '코멘트', with: '세금계산서 문서 상신'
  #   click_button '상신'

  #   simple_authenticate

  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '상세보기'

  #   fill_in '코멘트', with: '세금계산서 문서 승인'
  #   click_button '승인'

  #   normal_user_access

  #   visit '/documents/4'

  #   click_link '세금계산서 만들기'

  #   select '김 개똥 / 김 개똥 거래처', from: 'taxbill_taxman_id'

  #   click_button '세금계산서 만들기'

  #   select '김 관리', from: 'reporter'
  #   fill_in '코멘트', with: '세금계산서 상신'
  #   click_button '상신'

  #   assert(page.has_content?('상태 - 결재 대기 중'))

  #   simple_authenticate

  #   visit '/'
  #   click_link '세금계산서 관리'
  #   click_link '상세보기'

  #   assert(page.has_content?('김 개똥(normal): 세금계산서 상신'))
  #   assert(page.has_content?('김 개똥(normal): 김 관리(admin)님에게 결재를 요청하였습니다.'))

  #   fill_in '코멘트', with: '세금계산서 승인'
  #   click_button '승인'

  #   assert(page.has_content?('상태 - 결재 완료'))
  #   assert(page.has_content?('김 관리(admin): 세금계산서 승인'))
  #   assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 승인하였습니다.'))

  #   fill_in '코멘트', with: '세금계산서 반려'
  #   click_button '반려'

  #   assert(page.has_content?('상태 - 반려'))

  #   normal_user_access

  #   visit '/'
  #   click_link '세금계산서 관리'
  #   click_link '상세보기'
    
  #   assert(page.has_content?('김 관리(admin): 세금계산서 반려'))
  #   assert(page.has_content?('김 관리(admin): 김 관리님이 결재를 반려하였습니다.'))
  # end

  # test 'normal should not edit/delete admin document' do
  #   Document.destroy_all

  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   select "테스트 프로젝트", from: 'document_project_id'
  #   fill_in "문서제목", with: "수정/삭제 불가 문서"

  #   click_button '만들기'

  #   select '[개인] 김 개똥(normal)', from: 'accessor'

  #   click_button 'Save changes'

  #   normal_user_access

  #   visit '/'
  #   click_link '문서 관리'

  #   select '전체', from: 'report_status'
  #   fill_in "query", with: "수정/삭제 불가 문서"
  #   click_button "검색"
    
  #   click_link '상세보기'

  #   assert(page.has_content?("수정/삭제 불가 문서"))
  #   assert(!find('#show_command a').has_content?('수정하기'))
  #   assert(!find('#show_command a').has_content?('삭제하기'))
  # end

  # test 'should connect to employee' do
  #   visit '/'
  #   click_link '문서 관리'
  #   click_link '새로운 문서 작성'

  #   select "테스트 프로젝트", from: 'document_project_id'
  #   fill_in "문서제목", with: "수정/삭제 불가 문서"

  #   click_button '만들기'

  #   assert(!page.has_content?('인사정보와 연결하기'))
  #   assert(!find('#descr').has_content?('인사정보'))

  #   fill_in '코멘트', with: '수정/삭제 불가 문서 상신'
  #   click_button '승인'

  #   click_link '인사정보와 연결하기'
  #   click_link '연결하기'

  #   assert(page.has_content?('연결고리'))
  #   assert(page.has_content?('인사정보'))

  #   find('#descr ul li').click_link('인사정보')

  #   assert(page.has_content?('사장'))
  #   assert(page.has_content?('123456-1234567'))
  #   assert(page.has_content?('test@test.com'))

  #   click_link '수정/삭제 불가 문서'

  #   assert(page.has_content?('문서 상세 정보'))
  # end
end