# encoding: UTF-8
require 'test_helper'

class EmployeeTest < ActionDispatch::IntegrationTest
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
  fixtures :required_tags
  fixtures :tags
  fixtures :companies

  test 'should visit employee list.' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    assert(page.has_content?('인사정보관리'))
    assert(page.has_content?('계정'))
  end

  test 'should visit employees' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    assert(page.has_content?('인사정보'))
  end

  test 'should create a new employee with contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'

    click_link '새로운 인사정보 입력'

    find("tr[7]").click_link('상세보기')

    fill_in "주민등록번호", with: "123456-7654321"

    click_button '만들기'

    assert(page.has_content?('새로운 직원'))
    assert(page.has_content?('no employee'))
    assert(page.has_content?('알바'))
    assert(page.has_content?('123456-7654321'))
    assert(page.has_content?('new_employee@test.com'))
    assert(page.has_content?('010-4321-4321'))
    assert(page.has_content?('경기도 남양주시'))
  end

  test 'should create a new contact and create a new employee' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '새로운 인사정보 입력'
    click_link '새로운 연락처 만들기'

    fill_in '성', with: '홍'
    fill_in '이름', with: '길동'
    fill_in '회사', with: 'Mintech'
    fill_in '부서', with: '민트기술'
    fill_in '직위', with: '기술직'

    fill_in '국가', with: '대한민국'
    fill_in '주', with: ''
    fill_in '도시', with: '서울시'
    fill_in '군/구', with: '금천구'
    fill_in '나머지', with: '가산동'
    fill_in '우편번호', with: '123-321'

    fill_in '이메일', with: 'test@test.com'

    fill_in '전화번호', with: '010-9080-8090'

    fill_in '내용', with: '홈페이지'

    click_button '연락처 만들기'

    assert(page.has_content?('홍 길동'))
    assert(page.has_content?('기술직'))

    find("tr[9]").click_link('상세보기')

    fill_in "주민등록번호", with: "222222-2222222"
    
    click_button '만들기'
    
    assert(page.has_content?('홍 길동'))
    assert(page.has_content?('no employee'))
    assert(page.has_content?('기술직'))
    assert(page.has_content?('222222-2222222'))
    assert(page.has_content?('test@test.com'))
    assert(page.has_content?('010-9080-8090'))
    assert(page.has_content?('대한민국 서울시 금천구 가산동 123-321'))
  end

  test 'should visit employees to find contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))
    assert(page.has_content?('전체 공개'))
  end

  test 'should visit employees to edit contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '주소록 찾기'

    click_link '수정'

    fill_in "군/구", with: "수정된 주소"
    fill_in "이메일", with: "123@wangsy.com"
    fill_in "전화번호", with: "123-1234"

    click_button '연락처 수정하기'

    assert(page.has_content?('수정된 주소'))
    assert(page.has_content?('123@wangsy.com'))
    assert(page.has_content?('123-1234'))
  end

  test 'should visit employees to destroy contact items' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '주소록 찾기'

    disable_confirm_box

    click_link '제거'

    assert(!page.has_content?('wangsy@wangsy.com'))
  end

  test 'should visit employees to destroy contact' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '주소록 찾기'

    assert(page.has_content?('연락처 관리'))

    disable_confirm_box

    click_link '삭제'

    assert(!page.has_content?('김 관리'))
  end

  test 'should visit employees to find payments' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '연봉 관리'

    assert(page.has_content?('연봉 관리'))
  end

  test 'should visit employees to find vacations' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '연차 관리'

    assert(page.has_content?('연차 관리'))
  end

  test 'should fail to get employment_proof' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'

    click_link '재직증명서'

    assert(page.has_content?('Check company attachment.'))
  end
  
  test 'should create retired employees' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link('상세보기')
    
    click_link '퇴직 처리'

    assert(page.has_content?('퇴직 처리'))

    click_button '갱신하기'

    assert(page.has_content?('연봉 일할 정산'))

    click_button '갱신하기'
    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should edit the exist employee' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link('상세보기')

    click_link '수정하기'

    fill_in "주민등록번호", with: "123456-0123456"

    click_button '갱신하기'

    assert(page.has_content?('인사정보이(가) 성공적으로 업데이트 되었습니다.'))
    assert(page.has_content?('123456-0123456'))
  end

  test 'should back' do
    visit '/'
    click_link '인사정보관리 - 사원목록'
    click_link '상세보기'
    click_link '돌아가기'

    assert(page.has_content?('인사정보관리'))
  end

  test 'should show retired employee' do
    switch_to_selenium
    
    visit '/'
    click_link '인사정보관리 - 사원목록'
    
    select '퇴직자', from: 'search_type'

    assert(page.has_content?('퇴 직자'))
  end
end