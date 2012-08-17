# encoding: UTF-8
require 'test_helper'

class NUEmployeeTest < ActionDispatch::IntegrationTest
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
    normal_user_access

    visit '/'
    click_link '인사정보관리 - 사원목록'

    assert(page.has_content?('김 관리'))
    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('카드영수증 매니저'))
    assert(page.has_content?('카드 사용자'))
    assert(!page.has_content?('퇴 직자'))
  end

  test 'should show detail employee.' do
    normal_user_access

    visit '/'
    click_link '인사정보관리 - 사원목록'

    find('tr[3]').click

    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('사원'))
    assert(page.has_content?('123456-1234568'))
  end

  test 'should find contact' do
    normal_user_access

    visit '/'
    click_link '인사정보관리 - 사원목록'

    find('tr[3]').click

    click_link '주소록 찾기'

    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('사원'))
    assert(page.has_content?('민트기술'))
  end

  test 'should search data' do
    normal_user_access

    visit '/'
    click_link '인사정보관리 - 사원목록'

    find_field('q').set("admin")
    find_field('q').native.send_key(:enter)

    assert(page.has_content?('김 관리'))

    find_field('q').set("normal")
    find_field('q').native.send_key(:enter)

    assert(page.has_content?('김 개똥'))

    find_field('q').set("admin@wangsy.com")
    find_field('q').native.send_key(:enter)

    assert(page.has_content?('김 관리'))

    find_field('q').set("normal@wangsy.com")
    find_field('q').native.send_key(:enter)

    assert(page.has_content?('김 개똥'))
  end
end