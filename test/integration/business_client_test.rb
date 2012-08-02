# encoding: UTF-8
require 'test_helper'

class BusinessClientTest < ActionDispatch::IntegrationTest
  fixtures :business_clients
  fixtures :contacts
  fixtures :taxmen

  test 'should visit business_client list' do
    visit '/'
    click_link '거래처 관리'

    assert(page.has_content?('거래처 관리'))
  end

  test 'should create a new business_client' do
    visit '/'
    click_link '거래처 관리'
    click_link '신규 작성'

    fill_in "거래처명", with: "거래처명 입력 테스트"
    fill_in "사업자 등록번호", with: "123-321-12345"
    fill_in "업종", with: "업종 입력 테스트"
    fill_in "업태", with: "업태 입력 테스트"
    fill_in "주소", with: "주소 입력 테스트"
    fill_in "대표자", with: "대표자 입력 테스트"

    click_button '거래처 만들기'

    assert(page.has_content?('거래처이(가) 성공적으로 생성되었습니다.'))
  end

  test 'should edit business_client' do
    visit '/'
    click_link '거래처 관리'
    find("tr.selectable").click
    click_link '수정하기'

    fill_in "거래처명", with: "거래처명 수정 테스트"
    fill_in "사업자 등록번호", with: "321-123-54321"
    fill_in "업종", with: "업종 수정 테스트"
    fill_in "업태", with: "업태 수정 테스트"
    fill_in "주소", with: "주소 수정 테스트"
    fill_in "대표자", with: "대표자 수정 테스트"

    click_button '거래처 수정하기'

    assert(page.has_content?('거래처이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should destroy business_client' do
    visit '/'
    click_link '거래처 관리'
    find("tr.selectable").click

    click_link '삭제하기'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('거래처이(가) 성공적으로 제거 되었습니다.'))
  end

  test 'should add taxman' do
    visit '/'
    click_link '거래처 관리'
    find("tr.selectable").click

    click_link '담당자 추가하기'

    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(popup)

    find("tr.selectable").click

    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(popup)
    
    assert(page.has_content?('왕 수용'))
  end
end