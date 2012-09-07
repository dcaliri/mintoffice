# encoding: UTF-8
require 'test_helper'

class NUUsedVacationTest < ActionDispatch::IntegrationTest
  fixtures :vacations
  fixtures :used_vacations
  fixtures :vacation_types
  fixtures :vacation_type_infos

  class ::ReportMailer
    def self.report(target, from, to, subject, message)
    end
  end 

  test 'should view used_vacation' do
    visit '/'
    visit '/vacations/2'

    click_link '연차 할당'

    fill_in "기간", with: "37"

    click_button '연차 만들기'

    normal_user_access

    visit '/'

    click_link '연차 내역'

    assert(page.has_content?('사용한 연차 내역이 없습니다'))
  end

  test 'should create a new used_vacation and report admin' do
    visit '/'
    visit '/vacations/2'

    click_link '연차 할당'

    fill_in "기간", with: "37"

    click_button '연차 만들기'

    normal_user_access

    visit '/'

    click_link '연차 내역'
    click_link '연차 사용 신청'

    select '기타', from: 'used_vacation_type_'
    fill_in "사유", with: "test"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차를 신청하였습니다. 신청 후에는 결재를 올려주세요.'))
    assert(page.has_content?('test'))

    select '김 관리', from: 'reporter'
    fill_in "코멘트", with: "연차 사용 신청"

    click_button '상신'

    assert(page.has_content?('상태 - 결재 대기 중'))

    visit '/'
    
    assert(page.has_content?('휴가 : 김 개똥(기타)'))
  end

  test 'should create a new half day vacation and report admin' do
    visit '/'
    visit '/vacations/2'

    click_link '연차 할당'

    fill_in "기간", with: "37"

    click_button '연차 만들기'

    normal_user_access

    visit '/'

    click_link '연차 내역'
    click_link '연차 사용 신청'

    select '기타', from: 'used_vacation_type_'
    fill_in "기간", with: "0.5"
    fill_in "사유", with: "test"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차를 신청하였습니다. 신청 후에는 결재를 올려주세요.'))
    assert(page.has_content?('test'))
    assert(page.has_content?('0.5 일'))

    select '김 관리', from: 'reporter'
    fill_in "코멘트", with: "연차 사용 신청"

    click_button '상신'

    assert(page.has_content?('상태 - 결재 대기 중'))

    click_link '목록'

    assert(page.has_content?('0.5 일'))

    visit '/'
    
    assert(page.has_content?('휴가 : 김 개똥(기타)'))
  end

  test 'should show employee data' do
    visit '/'
    visit '/vacations/2'

    click_link '연차 할당'

    fill_in "기간", with: "37"

    click_button '연차 만들기'

    normal_user_access

    visit '/'

    click_link '연차 내역'
    click_link '인사정보'

    assert(page.has_content?('김 개똥'))
  end
end