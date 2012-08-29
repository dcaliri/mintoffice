# encoding: UTF-8
require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  fixtures :contacts
  fixtures :contact_emails
  fixtures :contact_email_tags
  fixtures :contact_email_tags_contact_emails
  fixtures :contact_addresses
  fixtures :contact_address_tags
  fixtures :contact_address_tags_contact_addresses
  fixtures :contact_phone_numbers
  fixtures :contact_phone_number_tags
  fixtures :contact_phone_number_tags_contact_phone_numbers
  fixtures :contact_others
  fixtures :contact_other_tags
  fixtures :contact_other_tags_contact_others
  fixtures :tags
  fixtures :taggings

  test 'should visit contact list' do
    visit '/'
    click_link '연락처'

    assert(page.has_content?('연락처 관리'))
  end

  test 'should visit contact' do
    visit '/'
    click_link '연락처'
    click_link '상세보기'

    assert(page.has_content?('전체 공개 : 김 관리'))
    assert(!page.has_content?('태그목록'))
    assert(!find('#descr dl dd a').has_content?('수정'))
  end

  test 'should save google contact' do
    visit '/'
    click_link '연락처'
    click_link '구글 연락처에 저장하기'

    fill_in "Id", with: "zzilssun@wangsy.com"
    fill_in "Password", with: "sojl1024"

    click_button '저장하기'

    assert(page.has_content?('성공적으로 연락처를 저장했습니다.'))
  end

  test 'should load google contact' do
    visit '/'
    click_link '연락처'
    click_link '구글 연락처에서 읽어오기'

    fill_in "Id", with: "zzilssun@wangsy.com"
    fill_in "Password", with: "sojl1024"

    click_button '읽어오기'

    assert(page.has_content?('성공적으로 연락처를 읽어왔습니다.'))
  end

  test 'should create a new contact' do
    visit '/'
    click_link '연락처'
    click_link '새로운 연락처 만들기'

    fill_in "성", with: "성"
    fill_in "이름", with: "이름"
    fill_in "회사", with: "회사 입력 테스트"
    fill_in "부서", with: "부서 입력 테스트"
    fill_in "직위", with: "직위 입력 테스트"
    
    fill_in "국가", with: "국가 입력 테스트"
    fill_in "주", with: "주 입력 테스트"
    fill_in "도시", with: "도시 입력 테스트"
    fill_in "군/구", with: "군/구 입력 테스트"
    fill_in "나머지", with: "나머지 입력 테스트"
    fill_in "우편번호", with: "132-123 입력 테스트"

    fill_in "이메일", with: "test@test.com"

    fill_in "전화번호", with: "02-123-1234"

    fill_in "내용", with: "내용 입력 테스트"

    click_button '연락처 만들기'

    assert(page.has_content?('전체 공개 : 성 이름'))
  end  

  test 'should edit contact' do
    visit '/'
    click_link '연락처'
    click_link '상세보기'
    click_link '수정'

    assert(page.has_content?('김 개똥(normal)'))
    assert(page.has_content?('카드영수증 매니저(card_manager)'))
    assert(page.has_content?('카드 사용자(card_user)'))
    assert(!page.has_content?('퇴 직자(retired_user)'))

    fill_in "성", with: "성"
    fill_in "이름", with: "이름"
    fill_in "회사", with: "회사 수정 테스트"
    fill_in "부서", with: "부서 수정 테스트"
    fill_in "직위", with: "직위 수정 테스트"
    select '김 개똥(normal)', from: 'contact_owner_id'
    
    fill_in "국가", with: "국가 수정 테스트"
    fill_in "주", with: "주 수정 테스트"
    fill_in "도시", with: "도시 수정 테스트"
    fill_in "군/구", with: "군/구 수정 테스트"
    fill_in "나머지", with: "나머지 수정 테스트"
    fill_in "우편번호", with: "132-123 수정 테스트"

    fill_in "이메일", with: "test@test.com"

    fill_in "전화번호", with: "02-123-1234"

    fill_in "내용", with: "내용 수정 테스트"

    click_button '연락처 수정하기'

    assert(page.has_content?('전체 공개 : 성 이름'))
  end  

  test 'should destroy contact' do
    visit '/'
    click_link '연락처'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제'

    assert(!page.has_content?('김 관리'))
  end

  test 'should delete contact' do
    visit '/'
    click_link '연락처'
    click_link '상세보기'

    click_link '제거'

    assert(!page.has_content?('이메일'))
  end
end