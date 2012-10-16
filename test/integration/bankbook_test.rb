# encoding: UTF-8
require 'test_helper'

class BankBookTest < ActionDispatch::IntegrationTest
  fixtures :bankbooks

  test 'should visit bankbook list' do
    visit '/'
    click_link '통장 관리'

    assert(page.has_content?('신한 통장'))
    assert(page.has_content?('기업 통장'))
  end

  test 'should show bankbook' do
    visit '/'
    click_link '통장 관리'
    click_link '상세보기'

    assert(page.has_content?('신한 통장'))
    assert(page.has_content?('321-123-123456'))
    assert(page.has_content?('김 신한'))
  end	  

  test 'should create a new bankbook' do
    visit '/'
    click_link '통장 관리'
    click_link '신규 작성'

    fill_in '통장명', with: '적금 통장'
    fill_in '통장번호', with: '111-111111-111'
    select '기업은행 (003)', from: '은행 코드'
    fill_in '예금주', with: '김 인턴'

    click_button '통장 만들기'

    assert(page.has_content?('적금 통장'))
    assert(page.has_content?('111-111111-111'))
    assert(page.has_content?('기업은행'))
    assert(page.has_content?('김 인턴'))
  end

  test 'should edit bankbook' do
    visit '/'
    click_link '통장 관리'
    click_link '상세보기'

    click_link '수정하기'

    fill_in '통장명', with: '수정 통장'
    fill_in '통장번호', with: '222-22222-222'
    select '국민은행 (004)', from: '은행 코드'
    fill_in '예금주', with: '김 수정'

    click_button '통장 수정하기'

    assert(page.has_content?('수정 통장'))
    assert(page.has_content?('222-22222-222'))
    assert(page.has_content?('국민은행'))
    assert(page.has_content?('김 수정'))
  end

  test 'should destroy bankbook' do
    visit '/'
    click_link '통장 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('신한 통장'))
    assert(page.has_content?('기업 통장'))
  end
end