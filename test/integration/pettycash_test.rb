# encoding: UTF-8
require 'test_helper'

class PettyCashTest < ActionDispatch::IntegrationTest
  fixtures :pettycashes

  test 'should visit pettycash list' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))
  end

  test 'should show pettycash' do
    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    assert(page.has_content?('소액현금 내역'))
  end

  test 'should back pettycash list' do
    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    click_link '돌아가기'    

    assert(page.has_content?('소액현금관리'))
  end

  test 'should create a new pettycash' do
    visit '/'
    click_link '소액현금관리'

    click_link '새로운 소액 거래 작성'

    select('2011', :from => 'pettycash_transdate_1i')
    select('11', :from => 'pettycash_transdate_2i')
    select('15', :from => 'pettycash_transdate_3i')
    select('10', :from => 'pettycash_transdate_4i')
    select('15', :from => 'pettycash_transdate_5i')
    fill_in "수입금액", with: "20000"
    fill_in "지출금액", with: "10000"
    fill_in "사용처 상세내역", with: "상세내역 입력 테스트"

    click_button '만들기'

    assert(page.has_content?('20,000'))
    assert(page.has_content?('10,000'))
    assert(page.has_content?('상세내역 입력 테스트'))
  end

  test 'should edit pettycash' do
    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    click_link '수정하기'

    select('2012', :from => 'pettycash_transdate_1i')
    select('1', :from => 'pettycash_transdate_2i')
    select('26', :from => 'pettycash_transdate_3i')
    select('11', :from => 'pettycash_transdate_4i')
    select('16', :from => 'pettycash_transdate_5i')
    fill_in "수입금액", with: "15000"
    fill_in "지출금액", with: "30000"
    fill_in "사용처 상세내역", with: "수정된 상세내역"

    click_button '소액현금 수정하기'

    assert(page.has_content?('15,000'))
    assert(page.has_content?('30,000'))
    assert(page.has_content?('수정된 상세내역'))
  end

  test 'should back pettycash list while editing' do
    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    click_link '수정하기'
    click_link '돌아가기'    

    assert(page.has_content?('소액현금관리'))
  end
end