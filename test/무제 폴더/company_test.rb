# encoding: UTF-8
require 'test_helper'

class CompanyTest < ActionDispatch::IntegrationTest
  test 'should show company' do
    visit '/'
    click_link '회사 관리'

    assert(page.has_content?('회사 정보'))
  end

  test 'should edit company' do
    visit '/'
    click_link '회사 관리'
    click_link '수정'

    fill_in "업체명", with: "mintech"
    fill_in "사업자 등록번호", with: "123-12-1234567"
    fill_in "대표자 성명", with: "김사장"
    fill_in "업체 주소", with: "가산동 디지털단지"
    fill_in "업체 연락처", with: "02-123-1234"
    select('19', from: 'company_pay_basic_date')
    select('24', from: 'company_payday')
    fill_in "구글앱스 도메인 이름", with: "test.com"
    fill_in "구글앱스 관리자 계정", with: "test"
    fill_in "구글앱스 관리자 비밀번호", with: "1234"
    fill_in "레드마인 도메인 이름", with: "redmine.test.com"
    fill_in "레드마인 관리자 계정", with: "test"
    fill_in "레드마인 관리자 비밀번호", with: "1234"
    fill_in "기본 비밀번호", with: "1234"
    select('김 개똥', from: 'company_apply_admin_id')
    fill_in "입사지원 필수 첨부자료", with: "이력서"

    path = File.join(::Rails.root, "test/fixtures/images/attachment_test_file.png")
    attach_file("company_attachments_attributes_0_uploaded_file", path)

    click_button '회사 수정하기'

    assert(page.has_content?('mintech'))
    assert(page.has_content?('김사장'))
    assert(page.has_content?('redmine.test.com'))
  end
end