# encoding: UTF-8
require 'test_helper'

class VacationTest < ActionDispatch::IntegrationTest
  fixtures :vacations
  fixtures :used_vacations

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

  test 'should edit vacations priod' do
    visit '/'
    
    click_link '연차 정보'
    click_link '수정'

    assert(page.has_content?('수정하기'))

    fill_in "기간", with: "5"

    click_button '연차 수정하기'

    assert(page.has_content?('연차 관리'))
  end

  test 'should destroy vacations priod' do
    visit '/'
    
    click_link '연차 정보'
    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('연차 정보'))
  end

  test 'should show hrinfo' do
    visit '/'
    
    click_link '연차 정보'
    click_link '인사정보'

    assert(page.has_content?('인사정보'))
  end

  test 'should create a new used_vacation' do
    visit '/'
    
    click_link '연차 정보'
    click_link '연차 사용 신청'

    assert(page.has_content?('연차 신청'))

    fill_in "사유", with: "test"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차를 신청하였습니다. 신청 후에는 결재를 올려주세요.'))
  end

  test 'should view used_vacation' do
    visit '/'
    
    click_link '연차 정보'
    find("tr.selectable").click

    assert(page.has_content?('사용한 연차 정보'))
  end

  test 'should commit report' do
    visit '/'
    
    click_link '연차 정보'
    find("tr.selectable").click

    assert(page.has_content?('사용한 연차 정보'))

    fill_in "코멘트", with: "test"

    click_button '승인'

    assert(page.has_content?('상태 - 결재 완료'))    
  end

#  test 'should change permission' do
#  end

  test 'should edit used_vacation' do
    visit '/'
    
    click_link '연차 정보'
    find("tr.selectable").click

    assert(page.has_content?('사용한 연차 정보'))

    click_link '수정하기'

    assert(page.has_content?('수정하기'))

    fill_in "사유", with: "수정된 사유"

    click_button '연차 사용 신청'

    assert(page.has_content?('연차 신청'))
  end

  test 'should destroy used_vacation' do
    visit '/'
    
    click_link '연차 정보'
    find("tr.selectable").click

    assert(page.has_content?('사용한 연차 정보'))

    click_link '삭제하기'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('연차 관리'))
  end

  test 'should return to list' do
    visit '/'
    
    click_link '연차 정보'
    find("tr.selectable").click

    assert(page.has_content?('사용한 연차 정보'))

    click_link '목록'

    assert(page.has_content?('연차 관리'))
  end

  test 'admin should show old user vacations' do
    visit '/vacations/2'

    assert(page.has_content?('김 개똥'))
    assert(page.has_content?('사용한 연차 내역이 없습니다'))
  end

  test 'normal should show old user vacations' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "1234"

    click_button '로그인'

    visit '/'
    click_link '연차 정보'

    assert(page.has_content?('Empty'))
  end
end