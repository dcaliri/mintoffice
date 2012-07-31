# encoding: UTF-8
require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  test 'show login' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "admin"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    assert(page.has_content?('Mint Office'))
  end

  test 'show logout' do
    click_link "로그아웃"
    
    assert(page.has_content?('로그인'))
  end
end