# encoding: UTF-8
require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  test 'show admin login' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "admin"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    assert(page.has_content?('Mint Office'))
  end

  test 'show normal login' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "normal"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    assert(page.has_content?('Mint Office'))
  end

#  test 'show google auth login' do
#    clear_session
#    
#    visit '/'
#
#    click_link '구글 계정으로 로그인'
#
#    fill_in "이메일", with: ""
#    fill_in "비밀번호", with: ""
#
#    click_button '로그인'
#
#    click_button '허용'
#
#    assert(page.has_content?('입사지원서 관리'))
#  end

  test 'login fail' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "no_account"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    assert(!page.has_content?('Mint Office'))
  end

  test 'show logout' do
    click_link "로그아웃"
    
    assert(page.has_content?('로그인'))
  end
end