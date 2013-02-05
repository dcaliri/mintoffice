# encoding: UTF-8
require 'test_helper'

class UsedVacationTest < ActionDispatch::IntegrationTest
  fixtures :vacations
  fixtures :used_vacations
  fixtures :vacation_types
  fixtures :vacation_type_infos
  fixtures :reports

  test 'should view used_vacation' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    assert(page.has_content?('사용한 연차 정보'))
  end

  test 'should create a new used_vacation' do
    visit '/'
    
    click_link '연차 내역'
    click_link '연차 사용 신청'

    select '기타', from: 'used_vacation_type_'
    fill_in "사유", with: "test"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차를 신청하였습니다. 신청 후에는 결재를 올려주세요.'))
    assert(page.has_content?('test'))
  end

  test 'should create a new half day vacation' do
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

    visit '/vacations/1'
    
    assert(page.has_content?('(0.5일)'))
  end

  test 'should commit report' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    fill_in "코멘트", with: "test"

    click_button '승인'

    assert(page.has_content?('상태 - 결재 완료'))
  end

  test 'should create/destroy permission' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    select '읽기', from: 'access_type'
    select '김 개똥', from: 'accessor'

    click_button '변경하기'

    assert(page.has_content?('성공적으로 권한을 설정하였습니다.'))

    click_link '[x]'

    assert(page.has_content?('성공적으로 권한을 제거하였습니다.'))
  end

  test 'should edit used_vacation' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    click_link '수정하기'

    select '병원 치료', from: 'used_vacation_type_'
    fill_in "사유", with: "수정된 사유"

    click_button '연차 사용 신청'

    assert(page.has_content?('수정된 사유'))
  end

  test 'should edit to half day' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    click_link '수정하기'

    select '병원 치료', from: 'used_vacation_type_'
    fill_in "기간", with: "0.5"
    fill_in "사유", with: "수정된 사유"

    click_button '연차 사용 신청'
    
    assert(page.has_content?('수정된 사유'))
    assert(page.has_content?('0.5 일'))

    visit '/vacations/1'

    assert(page.has_content?('(0.5일)'))
  end

  test 'should destroy used_vacation' do
    visit '/'

    click_link '연차 내역'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(page.has_content?('사용한 연차 내역이 없습니다'))
  end
end