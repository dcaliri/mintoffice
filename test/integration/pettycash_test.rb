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

    assert(page.has_content?('소액현금관리'))

    find("tr.selectable").click

    assert(page.has_content?('소액현금 내역'))
  end

  test 'should back pettycash list' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))

    find("tr.selectable").click

    assert(page.has_content?('소액현금 내역'))

    click_link '돌아가기'    

    assert(page.has_content?('소액현금관리'))
  end

  test 'should create a new pettycash' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))

    click_link '새로운 소액 거래 작성'

    assert(page.has_content?('새로운 소액 거래 작성'))

    select('2011', :from => 'pettycash_transdate_1i')
    select('11', :from => 'pettycash_transdate_2i')
    select('15', :from => 'pettycash_transdate_3i')
    select('10', :from => 'pettycash_transdate_4i')
    select('15', :from => 'pettycash_transdate_5i')
    fill_in "수입금액", with: "20000"
    fill_in "지출금액", with: "20000"
    fill_in "사용처 상세내역", with: "상세내역 입력 테스트"

    click_button '만들기'

    assert(page.has_content?('Pettycash was successfully created.'))
  end

  test 'should edit pettycash' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))

    find("tr.selectable").click

    assert(page.has_content?('소액현금 내역'))

    click_link '수정하기'

    assert(page.has_content?('소액현금 거래내용 수정'))

    select('2012', :from => 'pettycash_transdate_1i')
    select('1', :from => 'pettycash_transdate_2i')
    select('26', :from => 'pettycash_transdate_3i')
    select('11', :from => 'pettycash_transdate_4i')
    select('16', :from => 'pettycash_transdate_5i')
    fill_in "수입금액", with: "10000"
    fill_in "지출금액", with: "10000"
    fill_in "사용처 상세내역", with: "수정된 상세내역"

    click_button '갱신하기'

    assert(page.has_content?('소액현금이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should show pettycash while editing' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))

    find("tr.selectable").click

    assert(page.has_content?('소액현금 내역'))

    click_link '수정하기'

    assert(page.has_content?('소액현금 거래내용 수정'))    

    click_link '내용 보기'    

    assert(page.has_content?('소액현금 내역'))
  end

  test 'should back pettycash list while editing' do
    visit '/'
    click_link '소액현금관리'

    assert(page.has_content?('소액현금관리'))

    find("tr.selectable").click

    assert(page.has_content?('소액현금 내역'))

    click_link '수정하기'

    assert(page.has_content?('소액현금 거래내용 수정'))    

    click_link '돌아가기'    

    assert(page.has_content?('소액현금관리'))
  end
end