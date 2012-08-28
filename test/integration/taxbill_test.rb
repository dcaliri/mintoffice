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
    click_link '상세보기'

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
    click_link '상세보기'

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
    click_link '상세보기'

    click_link '새로운 내역'

    fill_in "품목단가", with: "10000"
    fill_in "품목수량", with: "32"
    fill_in "비고", with: "비고 입력 테스트"

    click_button '항목 만들기'

    assert(page.has_content?('항목이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('10,000'))
    assert(page.has_content?('32'))
  end

  test 'should edit taxbill item' do
    visit '/'
    click_link '세금계산서 관리'
    click_link '상세보기'

    click_link '내용 보기'
    click_link '수정'

    fill_in "품목단가", with: "1000"
    fill_in "품목수량", with: "51"
    fill_in "비고", with: "비고 수정 테스트"

    click_button '항목 수정하기'

    assert(page.has_content?('항목이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('1,000'))
    assert(page.has_content?('51'))
  end

  test 'should destroy taxbill item' do
    visit '/'
    click_link '세금계산서 관리'
    click_link '상세보기'

    click_link '내용 보기'

    disable_confirm_box
    click_link '삭제'

    assert(page.has_content?('항목이(가) 성공적으로 제거 되었습니다.'))
  end

  test "should upload an excel file" do
    switch_to_selenium

    visit '/'
    click_link '세금계산서 관리'

    click_link '엑셀 파일 올리기'
    path = File.join(::Rails.root, "test/fixtures/excels/taxbill_fixture.xls") 
    attach_file("upload_file", path)

    click_button '미리보기'
    click_button '엑셀파일'

    assert(page.has_content?('매입 세금계산서'))
    assert(page.has_content?('2012-08-20'))
    assert(page.has_content?('Walk'))
    assert(page.has_content?('₩11,000,000'))

    visit '/business_clients'

    assert(page.has_content?('Walk'))
  end
end