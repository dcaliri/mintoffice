# encoding: UTF-8
require 'test_helper'

class CardUsedSourcesTest < ActionDispatch::IntegrationTest
  fixtures :creditcards
  fixtures :card_approved_sources
  fixtures :card_used_sources
  fixtures :bank_accounts

  test 'should visit card_used_sources list' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'

    assert(page.has_content?('신용카드 이용내역'))
  end

  test 'should show card_used_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    find("tr.selectable").click

    assert(page.has_content?('카드번호'))
    assert(page.has_content?('321-321-1234'))
  end

  test 'should create a new card_used_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    click_link '이용내역 올리기'

    fill_in "카드번호", with: "321-321-1234"
    fill_in "결제계좌번호", with: "123-321-1234"
    fill_in "결제은행명", with: "신한 은행"
    fill_in "카드소유자명", with: "손어지리"
    fill_in "사용구분", with: "사용구분 입력 테스트"
    fill_in "승인번호", with: "2"
    select('2011', :from => 'card_used_source_approved_at_1i')
    select('1월', :from => 'card_used_source_approved_at_2i')
    select('26', :from => 'card_used_source_approved_at_3i')
    select('11', :from => 'card_used_source_approved_at_4i')
    select('11', :from => 'card_used_source_approved_at_5i')
    select('2011', :from => 'card_used_source_approved_time_1i')
    select('1월', :from => 'card_used_source_approved_time_2i')
    select('26', :from => 'card_used_source_approved_time_3i')
    select('11', :from => 'card_used_source_approved_time_4i')
    select('11', :from => 'card_used_source_approved_time_5i')
    fill_in "매출종류코드", with: "123"
    fill_in "승인금액(원화)", with: ""
    fill_in "승인금액(외화)", with: ""
    fill_in "공금가액(원화)", with: "50000"
    fill_in "부가세", with: "10"
    fill_in "봉사료", with: "10000"
    fill_in "할부기간", with: "12"
    fill_in "외화거래일환률", with: ""
    fill_in "외화거래국가코드", with: ""
    fill_in "외화거래국가명", with: ""
    fill_in "가맹점사업자번호", with: "123-321"
    fill_in "가맹점명", with: "가맹점명 입력 테스트"
    fill_in "가맹점업종명", with: "가맹점업종명 입력 테스트"
    fill_in "가맹점우편번호", with: "123-123"
    fill_in "가맹점주소1", with: "가맹점주소1 입력 테스트"
    fill_in "가맹점주소2", with: "가맹점주소2 입력 테스트"
    fill_in "가맹점전화번호", with: "02-123-1234"

    click_button '카드 이용내역 만들기'

    assert(page.has_content?('입력 테스트'))
  end  

  test 'should edit card_used_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    find("tr.selectable").click
    click_link '수정'

    fill_in "카드번호", with: "321-321-1234"
    fill_in "결제계좌번호", with: "321-123-4321"
    fill_in "결제은행명", with: "기업 은행"
    fill_in "카드소유자명", with: "손어지리"
    fill_in "사용구분", with: "사용구분 수정 테스트"
    fill_in "승인번호", with: "2"
    select('2012', :from => 'card_used_source_approved_at_1i')
    select('2월', :from => 'card_used_source_approved_at_2i')
    select('27', :from => 'card_used_source_approved_at_3i')
    select('12', :from => 'card_used_source_approved_at_4i')
    select('12', :from => 'card_used_source_approved_at_5i')
    select('2012', :from => 'card_used_source_approved_time_1i')
    select('2월', :from => 'card_used_source_approved_time_2i')
    select('27', :from => 'card_used_source_approved_time_3i')
    select('12', :from => 'card_used_source_approved_time_4i')
    select('12', :from => 'card_used_source_approved_time_5i')
    fill_in "매출종류코드", with: "321"
    fill_in "승인금액(원화)", with: ""
    fill_in "승인금액(외화)", with: ""
    fill_in "공금가액(원화)", with: "40000"
    fill_in "부가세", with: "20"
    fill_in "봉사료", with: "20000"
    fill_in "할부기간", with: "3"
    fill_in "외화거래일환률", with: ""
    fill_in "외화거래국가코드", with: ""
    fill_in "외화거래국가명", with: ""
    fill_in "가맹점사업자번호", with: "321-123"
    fill_in "가맹점명", with: "가맹점명 수정 테스트"
    fill_in "가맹점업종명", with: "가맹점업종명 수정 테스트"
    fill_in "가맹점우편번호", with: "321-321"
    fill_in "가맹점주소1", with: "가맹점주소1 수정 테스트"
    fill_in "가맹점주소2", with: "가맹점주소2 수정 테스트"
    fill_in "가맹점전화번호", with: "02-123-1234"

    click_button '카드 이용내역 수정하기'

    assert(page.has_content?('수정 테스트'))
  end  

  test 'should destroy card_used_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    find("tr.selectable").click

    click_link '삭제'    
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('신용카드 이용내역'))
  end

  test 'should export excel' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    click_link 'Excel'    
    assert(page.has_content?('신용카드 이용내역'))
  end

  test 'should export PDF' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 이용내역'
    click_link 'PDF'
    assert(page.has_content?('신용카드 이용내역'))
  end
end