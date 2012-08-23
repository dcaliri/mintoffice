# encoding: UTF-8
require 'test_helper'

class TaxBillTest < ActionDispatch::IntegrationTest
  fixtures :taxbills
  fixtures :taxbill_items
  fixtures :taxmen
  fixtures :business_clients
  fixtures :contacts
  fixtures :contact_phone_numbers
  fixtures :contact_emails

  test 'should visit taxbill list' do
    visit '/'
    click_link '세금계산서 관리'

    assert(page.has_content?('세금계산서 관리'))
  end

  test 'should show total taxbills' do
    visit '/'
    click_link '세금계산서 관리'
    click_link '합계표 보기'

    assert(page.has_content?('매입처별 합계'))
  end

  test 'should create a new taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    click_link '신규 작성'
    
    click_button '세금계산서 만들기'

    assert(page.has_content?('세금계산서이(가) 성공적으로 생성되었습니다.'))
  end


  test 'should edit taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    find("tr.selectable").click

    click_link '수정하기'

    select('2011', :from => 'taxbill_transacted_at_1i')
    select('1월', :from => 'taxbill_transacted_at_2i')
    select('10', :from => 'taxbill_transacted_at_3i')

    click_button '세금계산서 수정하기'

    assert(page.has_content?('세금계산서이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should destroy taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    find("tr.selectable").click

    disable_confirm_box

    click_link '삭제하기'


    assert(page.has_content?('세금계산서이(가) 성공적으로 제거 되었습니다.'))
  end  

  test 'should view purchase taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    visit '/taxbills/1'

    assert(page.has_content?('매입 세금계산서'))
  end

  test 'should view sale taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    visit '/taxbills/2'

    assert(page.has_content?('매출 세금계산서'))
  end

  test 'should create a new taxbill item' do
    visit '/'
    click_link '세금계산서 관리'
    find("tr.selectable").click

    click_link '새로운 내역'

    fill_in "단가", with: "10000"
    fill_in "수량", with: "10"
    fill_in "내역", with: "내역 입력 테스트"

    click_button '항목 만들기'

    assert(page.has_content?('항목이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('10,000'))
    assert(page.has_content?('10'))
    assert(page.has_content?('내역 입력 테스트'))
  end

  test 'should edit taxbill item' do
    visit '/'
    click_link '세금계산서 관리'
    find("tr.selectable").click

    click_link '수정'

    fill_in "단가", with: "1000"
    fill_in "수량", with: "5"
    fill_in "내역", with: "내역 수정 테스트"

    click_button '항목 수정하기'

    assert(page.has_content?('항목이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('1,000'))
    assert(page.has_content?('5'))
    assert(page.has_content?('내역 수정 테스트'))
  end

  test 'should destroy taxbill item' do
    visit '/'
    click_link '세금계산서 관리'
    find("tr.selectable").click

    disable_confirm_box

    click_link '삭제'

    assert(page.has_content?('항목이(가) 성공적으로 제거 되었습니다.'))
  end
end