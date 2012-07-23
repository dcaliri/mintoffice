# encoding: UTF-8
require 'test_helper'

class HrinfoTest < ActionDispatch::IntegrationTest
  fixtures :hrinfos
  fixtures :users
  fixtures :groups
  fixtures :groups_users
  fixtures :contacts
  fixtures :required_tags
  fixtures :tags
  fixtures :companies

  test 'should visit hrinfo list.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    assert(page.has_content?('인사정보관리'))
    assert(page.has_content?('계정'))
    assert(page.has_content?('admin'))
  end

  test 'should visit hrinfos' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    assert(page.has_content?('인사정보'))
  end

  test 'should create a new hrinfo' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    assert(page.has_content?('인사정보관리'))

    click_link '새로운 인사정보 입력'

    assert(page.has_content?('새로운 인사정보 입력'))

    fill_in "성", with: "손"
    fill_in "이름", with: "어지리"
    fill_in "주민등록번호", with: "123456-7654321"
    fill_in "이메일", with: "test@test.com"
    fill_in "핸드폰번호", with: "010-1234-3214"
    fill_in "주소", with: "금천구 가산동"
    fill_in "부서", with: "기술개발팀"
    fill_in "직급", with: "인턴"

    click_button '만들기'

    assert(page.has_content?('인사정보'))
  end

  test 'should visit hrinfos to find contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))
    assert(page.has_content?('전체 공개'))
  end

  test 'should create required tag.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '필수 태그 신규 작성'

    assert(page.has_content?('필수 태그 신규 작성'))
    assert(page.has_content?('모델명'))
    assert(page.has_content?('태그명'))

    fill_in "태그", with: "test2"

    click_button '만들기'
    assert(page.has_content?('Required Tag was successfully created.'))
  end

  test 'should not create same required tag.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '필수 태그 신규 작성'

    assert(page.has_content?('필수 태그 신규 작성'))
    assert(page.has_content?('모델명'))
    assert(page.has_content?('태그명'))

    fill_in "태그", with: "test"

    click_button '만들기'
    assert(page.has_content?('모델명 이미 사용중입니다.'))
  end

  test 'should visit hrinfos to find payments' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit hrinfos to find vacations' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '연차 관리'

    assert(page.has_content?('연차 관리'))
  end

#  test 'should fail to get employment_proof' do
#    visit '/'
#    click_link '인사정보관리 - 사원목록'
#    find("tr.selectable").click
#
#    click_link '재직증명서'
#
#    assert(page.has_content?('재직증명서'))
#
#    fill_in "용도", with: "test"
#
#    click_button '출력'
#
#    assert(page.has_content?('Check company attachment.'))
#  end

  test 'should visit hrinfos to retire' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '퇴직 처리'

    assert(page.has_content?('퇴직 처리'))

    click_button '갱신하기'

    assert(page.has_content?('연봉 일할 정산'))

    click_button '갱신하기'

    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should edit the exist hrinfo' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '수정하기'

    assert(page.has_content?('인사정보 수정'))
    
    fill_in "주민등록번", with: "123456-0123456"
    fill_in "이메일", with: "zzilssun@wangsy.com"
    fill_in "핸드폰번호", with: "010-5678-5678"
    fill_in "주소", with: "수정된 주소"

    click_button '갱신하기'

    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should back' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    find("tr.selectable").click

    click_link '돌아가기'

    assert(page.has_content?('인사정보관리'))
  end
end