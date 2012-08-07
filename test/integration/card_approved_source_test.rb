# encoding: UTF-8
require 'test_helper'

class CardApprovedSourcesTest < ActionDispatch::IntegrationTest
  fixtures :creditcards
  fixtures :card_approved_sources
  fixtures :card_used_sources
  fixtures :bank_accounts

  test 'should visit card_approved_sources list' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'

    assert(page.has_content?('카드승인내역'))
  end

  test 'should show card_approved_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    find("tr.selectable").click

    assert(page.has_content?('카드승인내역'))
  end

  test 'should create a new card_approved_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '승인내역 올리기'

    select('2011', :from => 'card_approved_source_used_at_1i')
    select('1월', :from => 'card_approved_source_used_at_2i')
    select('26', :from => 'card_approved_source_used_at_3i')
    select('11', :from => 'card_approved_source_used_at_4i')
    select('11', :from => 'card_approved_source_used_at_5i')
    fill_in "승인번호", with: "2146"
    fill_in "이용카드", with: "식대카드"
    fill_in "이용자명", with: "손어지리"
    fill_in "가맹점", with: "가맹점 입력 테스트"
    fill_in "이용금액", with: "50000"
    fill_in "이용구분", with: "4500"
    fill_in "할부개월수", with: "12"
    fill_in "카드구분", with: "체크카드"
    select('2011', :from => 'card_approved_source_canceled_at_1i')
    select('1월', :from => 'card_approved_source_canceled_at_2i')
    select('26', :from => 'card_approved_source_canceled_at_3i')
    select('11', :from => 'card_approved_source_canceled_at_4i')
    select('11', :from => 'card_approved_source_canceled_at_5i')
    fill_in "매입상태", with: "매입상태 입력 테스트"
    select('2011', :from => 'card_approved_source_will_be_paied_at_1i')
    select('1월', :from => 'card_approved_source_will_be_paied_at_2i')
    select('26', :from => 'card_approved_source_will_be_paied_at_3i')

    click_button '카드 승인내역 만들기'

    assert(page.has_content?('2146'))
    assert(page.has_content?('식대카드'))
    assert(page.has_content?('손어지리'))
    assert(page.has_content?('가맹점 입력 테스트'))
    assert(page.has_content?('50,000'))
    assert(page.has_content?('4500'))
    assert(page.has_content?('12'))
    assert(page.has_content?('체크카드'))
    assert(page.has_content?('매입상태 입력 테스트'))
  end

  test 'should edit card_approved_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    find("tr.selectable").click
    click_link '수정'

    select('2012', :from => 'card_approved_source_used_at_1i')
    select('2월', :from => 'card_approved_source_used_at_2i')
    select('27', :from => 'card_approved_source_used_at_3i')
    select('12', :from => 'card_approved_source_used_at_4i')
    select('12', :from => 'card_approved_source_used_at_5i')
    fill_in "승인번호", with: "1345"
    fill_in "이용카드", with: "식대카드 수정"
    fill_in "이용자명", with: "손어지리 수정"
    fill_in "가맹점", with: "가맹점 수정 테스트"
    fill_in "이용금액", with: "60000"
    fill_in "이용구분", with: "4700"
    fill_in "할부개월수", with: "120"
    fill_in "카드구분", with: "체크카드 수정"
    select('2012', :from => 'card_approved_source_canceled_at_1i')
    select('2월', :from => 'card_approved_source_canceled_at_2i')
    select('27', :from => 'card_approved_source_canceled_at_3i')
    select('12', :from => 'card_approved_source_canceled_at_4i')
    select('12', :from => 'card_approved_source_canceled_at_5i')
    fill_in "매입상태", with: "매입상태 수정 테스트"
    select('2012', :from => 'card_approved_source_will_be_paied_at_1i')
    select('2월', :from => 'card_approved_source_will_be_paied_at_2i')
    select('27', :from => 'card_approved_source_will_be_paied_at_3i')

    click_button '카드 승인내역 수정하기'

    assert(page.has_content?('1345'))
    assert(page.has_content?('식대카드 수정'))
    assert(page.has_content?('손어지리 수정'))
    assert(page.has_content?('가맹점 수정 테스트'))
    assert(page.has_content?('60,000'))
    assert(page.has_content?('4700'))
    assert(page.has_content?('120'))
    assert(page.has_content?('체크카드 수정'))
    assert(page.has_content?('매입상태 수정 테스트'))
  end

  test 'should destroy card_approved_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    find("tr.selectable").click
    
    click_link '삭제'
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('카드승인내역'))
  end

  test 'should create cardbill' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '신용카드 영수증 생성'

    select('normal', from: 'owner')
    click_button '카드영수증 생성'

    assert(page.has_content?('normal 이(가) 총 2개의 카드영수증을 생성했습니다.'))
  end

  test 'should show list without cardbill' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link '카드영수증이 없는 목록 보기'

    assert(!page.has_content?('Empty'))
  end

  test 'should export excel' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link 'Excel'
    assert(page.has_content?('카드승인내역'))
  end

  test 'should export PDF' do
    visit '/'
    click_link '신용카드 관리'
    click_link '카드별 승인내역'
    click_link 'PDF'
    assert(page.has_content?('카드승인내역'))
  end
end