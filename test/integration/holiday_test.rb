# encoding: UTF-8
require 'test_helper'

class HolidayTest < ActionDispatch::IntegrationTest
  fixtures :holidays

  test 'should visit holiday list' do
    visit '/'
    click_link '휴일 관리'

    assert(page.has_content?('광복절'))
  end

  test 'should show holiday' do
    visit '/'
    click_link '휴일 관리'
    click_link '상세보기'

    assert(page.has_content?('광복절'))
  end

  test 'should create a new holiday' do
    visit '/'
    click_link '휴일 관리'
    click_link '신규 작성'

    fill_in "휴일명목", with: "휴일명목 입력 테스트"

    click_button '휴일관리 만들기'

    assert(page.has_content?('휴일명목 입력 테스트'))

    visit '/'

    assert(page.has_content?('휴일명목 입력 테스트'))
  end

  test 'should edit holiday' do
    visit '/'
    click_link '휴일 관리'
    click_link '신규 작성'

    fill_in "휴일명목", with: "휴일명목 입력 테스트"

    click_button '휴일관리 만들기'

    click_link '수정하기'

    fill_in "휴일명목", with: "휴일명목 수정 테스트"
    click_button '휴일관리 수정하기'

    visit '/'
    assert(page.has_content?('휴일명목 수정 테스트'))
  end

  test 'should destroy holiday' do
    visit '/'
    click_link '휴일 관리'
    click_link '상세보기'

    click_link '삭제하기'

    assert(!page.has_content?('광복절'))
  end
end