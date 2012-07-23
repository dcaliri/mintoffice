# encoding: UTF-8
require 'test_helper'

class VacationTest < ActionDispatch::IntegrationTest
  fixtures :vacations
  fixtures :hrinfos
  fixtures :used_vacations
  fixtures :users
  fixtures :groups
  fixtures :groups_users

  test 'should visit vacations list for admin' do
    visit '/'
    
    visit '/vacations'

		assert(page.has_content?('연차 정보'))
  end

  test 'should visit vacations' do
    visit '/'
    
    click_link '연차 정보'

    assert(page.has_content?('연차 관리'))
  end

  test 'should create a new vacations priod' do
    visit '/'
    
    click_link '연차 정보'
    click_link '연차 할당'

    fill_in "기간", with: "10"

    click_button '연차 만들기'

    assert(page.has_content?('연차 관리'))
  end

  test 'should show hrinfo' do
    visit '/'
    
    click_link '연차 정보'
    click_link '인사정보'

    assert(page.has_content?('인사정보'))
  end

  test 'should create a new used_vacations' do
    visit '/'
    
    click_link '연차 정보'
    click_link '연차 사용 신청'

    assert(page.has_content?('연차 신청'))

    fill_in "사유", with: "test"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차를 신청하였습니다. 신청 후에는 결재를 올려주세요.'))

    fill_in "코멘트", with: "test"
    click_button '승인'

    assert(page.has_content?('결재를 승인하였습니다.'))
  end
end