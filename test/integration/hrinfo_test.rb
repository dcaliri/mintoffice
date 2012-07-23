# encoding: UTF-8
require 'test_helper'

class HrinfoTest < ActionDispatch::IntegrationTest
  fixtures :hrinfos
  fixtures :users
  fixtures :groups
  fixtures :groups_users
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

  test 'should visit hrinfos to find contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))
    assert(page.has_content?('전체 공개'))
  end

  test 'should visit hrinfos to edit contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))

    click_link '수정'

    fill_in "군/구", with: "수정된 주소"
    fill_in "이메일", with: "123@wangsy.com"
    fill_in "전화번", with: "123-1234"

    click_button '연락처 수정하기'

    assert(page.has_content?('연락처 관리'))
  end

  test 'should visit hrinfos to destroy contact items' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))

    click_link '제거'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('연락처 관리'))
  end

  test 'should visit hrinfos to destroy contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))

    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('연락처 관리'))
  end
end