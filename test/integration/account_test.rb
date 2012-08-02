# encoding: UTF-8
require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest

  test 'should visit account list' do
    visit '/'
    click_link '사용자 계정 목록'

    assert(page.has_content?('사용자 계정 목록'))
  end

  test 'should view account' do
    visit '/'
    click_link '사용자 계정 목록'
    find("tr.selectable").click

    assert(page.has_content?('사용자 계정 정보'))
  end

#  test 'should view account with google apps' do
#    visit '/'
#    click_link '사용자 계정 목록'
#    click_link '구글 앱스 계정이 등록된 사용자들 보기'
#
#    assert(page.has_content?('사용자 계정 목록'))
#  end

  test 'should create a new account' do
    visit '/'
    click_link '사용자 계정 목록'
    click_link '새로운 사용자 등록'

    fill_in "계정명", with: "test"
    fill_in "비밀번호", with: "1234"
    fill_in "비밀번호 확인", with: "1234"
    fill_in "이메일", with: "test@test.com"
    fill_in "Boxcar 계정", with: "test@boxcar.com"
    fill_in "Redmine 계정", with: "test"

    click_button '만들기'

    assert(page.has_content?('사용자계정이(가) 성공적으로 생성되었습니다.'))
  end

  test 'should edit account' do
    visit '/'
    click_link '사용자 계정 목록'
    find("tr.selectable").click
    click_link '수정하기'

    fill_in "계정명", with: "test"
    fill_in "비밀번호", with: "1234"
    fill_in "비밀번호 확인", with: "1234"
    fill_in "이메일", with: "test@test.com"
    fill_in "Boxcar 계정", with: "test@boxcar.com"
    fill_in "Redmine 계정", with: "test"

    click_button '만들기'

    assert(page.has_content?('사용자계정이(가) 성공적으로 업데이트 되었습니다.'))
    assert(page.has_content?('test@test.com'))
    assert(page.has_content?('test@boxcar.com'))
  end

  test 'should change password' do
    visit '/'
    click_link '사용자 계정 목록'
    find("tr.selectable").click
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

    find_field('q').set("normal")
    find_field('q').native.send_key(:enter)

    assert(page.has_content?('normal'))
  end
end