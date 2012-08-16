  # encoding: UTF-8
require 'test_helper'

class EmployeeTest < ActionDispatch::IntegrationTest
  fixtures :contacts
  fixtures :contact_emails
  fixtures :contact_email_tags
  fixtures :contact_email_tags_contact_emails
  fixtures :contact_addresses
  fixtures :contact_address_tags
  fixtures :contact_address_tags_contact_addresses
  fixtures :contact_phone_numbers
  fixtures :contact_phone_number_tags
  fixtures :contact_phone_number_tags_contact_phone_numbers
  fixtures :contact_others
  fixtures :contact_other_tags
  fixtures :contact_other_tags_contact_others
  fixtures :required_tags
  fixtures :tags
  fixtures :companies

  test 'should visit employee list.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    assert(page.has_content?('인사정보관리'))
    assert(page.has_content?('계정'))
    assert(page.has_content?('admin'))
  end

  test 'should visit employees' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    assert(page.has_content?('인사정보'))
  end

  test 'should create a new employee' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    click_link '새로운 인사정보 입력'
    find("tr.selectable").click

    fill_in "주민등록번호", with: "123456-7654321"

    click_button '만들기'

    assert(page.has_content?('123456-7654321'))
  end

  test 'should visit employees to find contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))
    assert(page.has_content?('전체 공개'))
  end

  test 'should visit employees to edit contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    click_link '수정'

    fill_in "군/구", with: "수정된 주소"
    fill_in "이메일", with: "123@wangsy.com"
    fill_in "전화번호", with: "123-1234"

    click_button '연락처 수정하기'

    assert(page.has_content?('수정된 주소'))
    assert(page.has_content?('123@wangsy.com'))
    assert(page.has_content?('123-1234'))
  end

  test 'should visit employees to destroy contact items' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    disable_confirm_box

    click_link '제거'

    assert(!page.has_content?('wangsy@wangsy.com'))
  end

  test 'should visit employees to destroy contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))

    disable_confirm_box

    click_link '삭제'

    assert(!page.has_content?('김 관리'))
  end

  test 'should create required tag.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '필수 태그 신규 작성'

    assert(page.has_content?('필수 태그 신규 작성'))
    assert(page.has_content?('모델명'))
    assert(page.has_content?('태그명'))

    fill_in "태그", with: "test2"

    click_button '만들기'
    assert(page.has_content?('Required Tag was successfully created.'))
  end

  test 'should not create same required tag.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '필수 태그 신규 작성'

    assert(page.has_content?('필수 태그 신규 작성'))
    assert(page.has_content?('모델명'))
    assert(page.has_content?('태그명'))

    fill_in "태그", with: "test"

    click_button '만들기'
    assert(page.has_content?('모델명 이미 사용중입니다.'))
  end

  test 'should visit employees to find payments' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit employees to find vacations' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '연차 관리'

    assert(page.has_content?('연차 관리'))
  end

  test 'should success to get employment_proof' do
    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end

    switch_to_rack_test

    visit '/employees/1/employment_proof'

    fill_in "용도", with: "test"

    click_button '출력'

    assert_equal(page.response_headers['Content-Disposition'], "attachment; filename=\"김 관리_employment_proof.pdf\"")
  end

  test 'should fail to get employment_proof' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '재직증명서'

    assert(page.has_content?('Check company attachment.'))
  end

  test 'should visit employees to retire' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '퇴직 처리'

    assert(page.has_content?('퇴직 처리'))

    click_button '갱신하기'

    assert(page.has_content?('연봉 일할 정산'))

    click_button '갱신하기'

    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should edit the exist employee' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '수정하기'

    assert(page.has_content?('인사정보 수정'))

    fill_in "주민등록번호", with: "123456-0123456"

    click_button '갱신하기'

    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))

    assert(page.has_content?('123456-0123456'))
  end

  test 'should back' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click
    click_link '돌아가기'

    assert(page.has_content?('인사정보관리'))
  end
end