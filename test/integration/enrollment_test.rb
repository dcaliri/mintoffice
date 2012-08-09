# encoding: UTF-8
require 'test_helper'

class EnrollmentTest < ActionDispatch::IntegrationTest

  test 'show enrollment process' do
    clear_session
    
    visit '/'

    fill_in "사용자계정", with: "google_account_user"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    visit '/enrollments/dashboard'
    click_link '기본정보 등록'

    fill_in '주민등록번호', with: '111111-1111111'
    fill_in '성', with: '구글계정'
    fill_in '이름', with: '유저'

    fill_in '국가', with: '대한민국'
    fill_in '주', with: ''
    fill_in '도시', with: '경기도'
    fill_in '군/구', with: '금천구 가산동'
    fill_in '나머지', with: 'SK트윈타워'
    fill_in '우편번호', with: '123-123'

    fill_in '이메일', with: 'test@test.com'

    fill_in '전화번호', with: '010-123-1234'

    click_button '입사 지원 신청'
    
    assert(page.has_content?('입사지원서가 저장되었습니다.'))
    assert(page.has_content?('등록 완료'))
    click_link '추가하기'

    path = File.join(::Rails.root, "test/fixtures/images/attachment_test_file.png")
    attach_file("picture", path)
    click_button '추가'

    assert(page.has_content?('attachment_test_file.png'))
    click_link '돌아가기'

    click_button '상신'
    assert(page.has_content?('google_account_user: admin님에게 결재를 요청하였습니다.'))

    clear_session

    visit '/'

    fill_in "사용자계정", with: "admin"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"

    click_link '입사지원'
    assert(page.has_content?('구글계정 유저'))
    assert(page.has_content?('test@test.com'))
    assert(page.has_content?('010-123-1234'))

    find('tr.selectable').click

    fill_in '코멘트', with: '입사를 환영합니다.'
    click_button '승인'

    assert(page.has_content?('입사를 환영합니다.'))
  end
end