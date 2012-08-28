# encoding: UTF-8
require 'test_helper'

class ChangeHistoryTest < ActionDispatch::IntegrationTest
  fixtures :change_histories
  fixtures :pettycashes

  test 'should visit chage_history list' do
    visit '/'
    click_link '변경사항 관리'

    assert(page.has_content?('description'))
    assert(page.has_content?('변경 전 description'))
  end

  test 'should create a new chage_history' do
    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "사용처 상세내역", with: "변경 후 description"

    click_button '소액현금 수정하기'

    assert(page.has_content?('[소액현금] 사용처 상세내역: test → 변경 후 description(김 관리)'))

    visit '/'
    click_link '변경사항 관리'

    assert(page.has_content?('변경 후 description'))
  end

  test 'should edit chage_history' do
    visit '/'
    click_link '변경사항 관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "필드명", with: "inmoney"
    fill_in "이전 값", with: "50000.0"
    fill_in "이후 값", with: "100000.0"

    click_button '변경사항 수정하기'

    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    assert(page.has_content?('[소액현금] 수입금액: 50000.0 → 100000.0(김 관리)'))
  end

  test 'should destroy chage_history' do
    visit '/'
    click_link '변경사항 관리'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    visit '/'
    click_link '소액현금관리'
    click_link '상세보기'

    assert(!page.has_content?('[소액현금] 사용처 상세내역: 변경 전 description → test(김 관리)'))
  end
end