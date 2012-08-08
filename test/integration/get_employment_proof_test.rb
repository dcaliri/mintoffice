# encoding: UTF-8
require 'test_helper'

class GetEmploymentProofTest < ActionDispatch::IntegrationTest
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

  test 'admin should get his proof' do
    visit '/'
    click_link '회사 관리'
    click_link '수정'

    find_by_id('company_attachments_attributes_0_uploaded_file').click
    path = File.join(::Rails.root, "test/fixtures/images/seal.png")
    attach_file("company_attachments_attributes_0_uploaded_file", path)

    click_button '회사 수정하기'

    visit '/'
    click_link '인사정보관리 - 사원목록'

    visit '/hrinfos/1'
    click_link '재직증명서'

    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end

  test 'admin should get another employee proof' do
    visit '/'
    click_link '회사 관리'
    click_link '수정'

    find_by_id('company_attachments_attributes_0_uploaded_file').click
    path = File.join(::Rails.root, "test/fixtures/images/seal.png")
    attach_file("company_attachments_attributes_0_uploaded_file", path)

    click_button '회사 수정하기'

    visit '/'
    click_link '인사정보관리 - 사원목록'

    visit '/hrinfos/2'
    click_link '재직증명서'


    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end  

  test 'normal user should get his proof' do
    visit '/'
    click_link '회사 관리'
    click_link '수정'

    find_by_id('company_attachments_attributes_0_uploaded_file').click
    path = File.join(::Rails.root, "test/fixtures/images/seal.png")
    attach_file("company_attachments_attributes_0_uploaded_file", path)

    click_button '회사 수정하기'

    clear_session

    visit '/'

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "1234"

    click_button '로그인'

    click_link '인사정보관리 - 사원목록'
    visit '/hrinfos/2'
    click_link '재직증명서'

    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end

  test 'normal user should not get another employee proof' do
    visit '/'
    click_link '회사 관리'
    click_link '수정'

    find_by_id('company_attachments_attributes_0_uploaded_file').click
    path = File.join(::Rails.root, "test/fixtures/images/seal.png")
    attach_file("company_attachments_attributes_0_uploaded_file", path)

    click_button '회사 수정하기'

    clear_session

    visit '/'

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "1234"

    click_button '로그인'
    click_link '인사정보관리 - 사원목록'
    visit '/hrinfos/1/employment_proof'

    assert(page.has_content?("You don't have to permission"))
  end
end