# encoding: UTF-8
require 'test_helper'

class CreditCardTest < ActionDispatch::IntegrationTest
  fixtures :creditcards
  fixtures :card_approved_sources
  fixtures :card_used_sources
  fixtures :bank_accounts

  test 'should visit creditcard list' do
    visit '/'
    click_link '신용카드 관리'

    assert(page.has_content?('식대카드'))
    assert(page.has_content?('법인카드'))
    assert(page.has_content?('현대카드'))
  end

  test 'should show creditcard' do
    visit '/'
    click_link '신용카드 관리'
    click_link '상세보기'

    assert(page.has_content?('321-321-1234'))
  end

  test 'should create a new creditcard' do
    visit '/'
    click_link '신용카드 관리'
    click_link '신규 작성'

    fill_in "카드번호", with: "432-234-2345"
    fill_in "카드명칭", with: "카드명칭 입력 테스트"
    fill_in "만료연도", with: "2013"
    fill_in "만료월", with: "01"
    fill_in "별칭", with: "별칭 입력 테스트"
    fill_in "발급사", with: "발급사 입력 테스트"
    fill_in "소유자이름", with: "소유자이름 입력 테스트"
    select('HSBC : 123-321-3211234', from: 'creditcard_bank_account_id')

    click_button '만들기'

    assert(page.has_content?('신용카드이(가) 성공적으로 생성되었습니다.'))
  end

  test 'should edit creditcard' do
    visit '/'
    click_link '신용카드 관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "카드번호", with: "432-234-2345"
    fill_in "카드명칭", with: "카드명칭 수정 테스트"
    fill_in "만료연도", with: "2014"
    fill_in "만료월", with: "02"
    fill_in "별칭", with: "별칭 수정 테스트"
    fill_in "발급사", with: "발급사 수정 테스트"
    fill_in "소유자이름", with: "소유자이름 수정 테스트"
    select('신한 은행 : 321-123-123456', from: 'creditcard_bank_account_id')

    click_button '갱신하기'

    assert(page.has_content?('신용카드이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should show card_used_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '상세보기'
    click_link '카드별 이용내역'

    assert(page.has_content?('신용카드 이용내역'))
  end

  test 'should show card_approved_sources' do
    visit '/'
    click_link '신용카드 관리'
    click_link '상세보기'
    click_link '카드별 승인내역'

    assert(page.has_content?('카드승인내역'))
  end

  test 'should show total' do
    visit '/'
    click_link '신용카드 관리'
    click_link '합계표 보기'

    assert(page.has_content?('신용카드 관리'))
  end

  test "should upload an hyundaicard used excel file" do
    BankTransaction.destroy_all

    visit '/'
    click_link '신용카드 관리'
    click_link '엑셀 파일로 올리기'

    select '이용내역(현대카드)', from: 'card_type'

    path = File.join(::Rails.root, "test/fixtures/excels/hyundai-card_used_source_fixture.xlsx") 
    attach_file("upload_file", path)

    click_button '미리보기'
    click_button '엑셀 파일 올리기'

    click_link '카드별 이용내역'

    assert(page.has_content?('00993527'))
    assert(page.has_content?('가로수할인마트'))
    assert(page.has_content?('₩86,100'))
  end

  test "should upload an hyundaicard approved excel file" do
    BankTransaction.destroy_all

    visit '/'
    click_link '신용카드 관리'
    click_link '엑셀 파일로 올리기'

    select '승인내역(현대카드)', from: 'card_type'

    path = File.join(::Rails.root, "test/fixtures/excels/hyundai-card_approved_source_fixture.xlsx") 
    attach_file("upload_file", path)

    click_button '미리보기'
    click_button '엑셀 파일 올리기'

    click_link '카드별 승인내역'

    assert(page.has_content?('00300343'))
    assert(page.has_content?('아웃백코엑스점'))
    assert(page.has_content?('₩86,100'))
  end

end