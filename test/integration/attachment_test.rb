# encoding: UTF-8
require 'test_helper'

class AttachmentTest < ActionDispatch::IntegrationTest
  fixtures :documents
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :projects
  fixtures :project_assign_infos

  test 'should visit attachment list' do
    visit '/'
    click_link '첨부파일 관리'

    assert(page.has_content?('첨부파일'))
  end

  test 'should create a new attachment' do
    visit '/'
    click_link '첨부파일 관리'
    click_link '새로운 첨부 올리기'

    fill_in '제목', with: '첨부파일 제목 입력 테스트'
    fill_in '주석', with: '첨부파일 주석 입력 테스트'

    path = File.join(::Rails.root, "test/fixtures/images/attachment_test_file.png") 
    attach_file('attachment_uploaded_file', path)

    click_button '만들기'

    assert(page.has_content?('첨부파일이(가) 성공적으로 생성되었습니다.'))
    assert(page.has_content?('첨부파일 제목 입력 테스트'))
    assert(page.has_content?('첨부파일 주석 입력 테스트'))
    assert(page.has_content?('attachment_test_file.png'))
    assert(page.has_content?('김 관리'))
  end

  test 'should edit attachment' do
    visit '/'
    click_link '첨부파일 관리'
    click_link '새로운 첨부 올리기'

    fill_in '제목', with: '첨부파일 제목 입력 테스트'
    fill_in '주석', with: '첨부파일 주석 입력 테스트'

    path = File.join(::Rails.root, "test/fixtures/images/attachment_test_file.png") 
    attach_file('attachment_uploaded_file', path)

    click_button '만들기'

    click_link '상세보기'
    click_link '수정하기'

    fill_in '제목', with: '첨부파일 제목 수정 테스트'
    fill_in '주석', with: '첨부파일 주석 수정 테스트'
    fill_in '원 파일명', with: 'edit_attachment_test_file.png'

		click_button '갱신하기'

    assert(page.has_content?('첨부파일 제목 수정 테스트'))
    assert(page.has_content?('첨부파일 주석 수정 테스트'))
    assert(page.has_content?('edit_attachment_test_file.png'))
  end  

  test 'should cant create attachment with blank path' do
    visit '/'
    click_link '첨부파일 관리'
    click_link '새로운 첨부 올리기'

    fill_in '제목', with: '첨부파일 제목 입력 테스트'
    fill_in '주석', with: '첨부파일 주석 입력 테스트'

    click_button '만들기'

    assert(page.has_content?("저장된 파일명 can't be blank"))
  end

  test 'should check attachment_image in company attachment' do
	visit '/companies/1'
    click_link '수정'

    path = File.join(::Rails.root, "test/fixtures/images/attachment_test_file.png") 
    attach_file('company_attachments_attributes_0_uploaded_file', path)

    click_button '회사 수정하기'

    visit '/attachments'

    assert(page.has_content?('attachment_test_file.png'))
    assert(page.has_content?('image/png'))
    assert(page.has_content?('김 관리'))
  end

  test 'should check attachment_excel in document attachment' do
	visit '/documents/1'
    click_link '수정하기'

    path = File.join(::Rails.root, "test/fixtures/excels/bank_transfer_fixture.xls") 
    attach_file('document_attachments_attributes_0_uploaded_file', path)

    click_button '갱신하기'

    visit '/attachments'

    assert(page.has_content?('bank_transfer_fixture.xls'))
    assert(page.has_content?('application/vnd.ms-excel'))
    assert(page.has_content?('김 관리'))
  end
end