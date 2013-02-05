# encoding: UTF-8
require 'test_helper'

class VacationTest < ActionDispatch::IntegrationTest
  fixtures :vacations
  fixtures :used_vacations
  fixtures :reports

  test 'should visit vacations list for admin' do
    visit '/'
    visit '/vacations'
    
		assert(page.has_content?('연차 내역'))
  end

  test 'should visit vacations' do
    visit '/'
    click_link '연차 내역'

    assert(page.has_content?('연차 관리'))
  end

  test 'should create a new vacations priod' do
    visit '/'
    
    click_link '연차 내역'
    click_link '연차 할당'

    fill_in "기간", with: "37"

    click_button '연차 만들기'

    assert(page.has_content?('37'))
  end

  test 'should edit vacations priod' do
    visit '/'
    
    click_link '연차 내역'
    click_link '수정'

    assert(page.has_content?('수정하기'))

    fill_in "기간", with: "52"

    click_button '연차 수정하기'

    assert(page.has_content?('52'))
  end

  test 'should destroy vacations priod' do
    visit '/'

    click_link '연차 내역'

    disable_confirm_box

    click_link '삭제'

    assert(page.has_content?('연차 내역'))
  end

  test 'should show employee' do
    visit '/'
    
    click_link '연차 내역'
    click_link '인사정보'

    assert(page.has_content?('인사정보'))
  end

  test 'should return to list' do
    visit '/'
    
    click_link '연차 내역'
    click_link '상세보기'

    assert(page.has_content?('사용한 연차 정보'))

    click_link '목록'

    assert(page.has_content?('연차 내역'))
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
    click_link '연차 내역'

    assert(page.has_content?('Empty'))
  end
end