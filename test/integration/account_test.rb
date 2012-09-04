# encoding: UTF-8
require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest

  test 'should visit account list' do
    visit '/'
    click_link '사용자 계정 목록'

    assert(page.has_content?('admin'))
    assert(page.has_content?('normal'))
    assert(page.has_content?('no employee'))
    assert(page.has_content?('has_google_apps_account'))
  end

  test 'should view account' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '상세보기'

    assert(page.has_content?('admin'))
  end

  test 'should not view account with google apps' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '구글 앱스 계정이 등록된 사용자들 보기'

    assert(page.has_content?('Access fails to google apps'))
  end

  test 'should create a new account' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '새로운 사용자 등록'

    fill_in "계정명", with: "test_account"
    fill_in "비밀번호", with: "1234"
    fill_in "비밀번호 확인", with: "1234"
    fill_in "이메일", with: "test@test.com"
    fill_in "Boxcar 계정", with: "test@boxcar.com"

    click_button '만들기'

    assert(page.has_content?('사용자계정이(가) 성공적으로 생성되었습니다.'))

    visit '/accounts/12'

    assert(page.has_content?('test_account'))
    assert(page.has_content?('test@test.com'))
    assert(page.has_content?('test@boxcar.com'))
  end

  test 'should edit account' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "계정명", with: "edit_account"
    fill_in "이메일", with: "edit_test@test.com"
    fill_in "Boxcar 계정", with: "edit_test@boxcar.com"

    click_button '만들기'

    assert(page.has_content?('사용자계정이(가) 성공적으로 업데이트 되었습니다.'))
    
    assert(page.has_content?('edit_account'))
    assert(page.has_content?('edit_test@test.com'))
    assert(page.has_content?('edit_test@boxcar.com'))
  end

  test 'should change password' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '상세보기'
    click_link '수정하기'
    click_link '비밀번호 변경'

    fill_in "비밀번호", with: "1234"
    fill_in "비밀번호 확인", with: "1234"

    click_button '변경하기'

    assert(page.has_content?('성공적으로 변경하였습니다.'))
  end

  test 'should search by account name' do
    visit '/'
    click_link '사용자 계정 목록'

    fill_in "q", with: "normal"
    click_button "검색"

    assert(page.has_content?('normal'))
  end

  test 'normal should change password' do
    normal_user_access

    visit '/'
    click_link '김 개똥(normal)'

    click_link '비밀번호 변경'

    fill_in '비밀번호', with: '2345'
    fill_in '비밀번호 확인', with: '2345'

    click_button '변경하기'

    assert(page.has_content?('성공적으로 변경하였습니다.'))

    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    assert(page.has_content?('아이디 혹은 비밀번호가 잘못되었습니다.'))

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "2345"

    click_button "로그인"

    assert(page.has_content?('Mint Office'))
  end
end