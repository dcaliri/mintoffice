# encoding: UTF-8
require 'test_helper'

class UsedVacationTest < ActionDispatch::IntegrationTest
  fixtures :vacation_types
  fixtures :vacation_type_infos

  test 'should show vacation_types list' do
    visit '/'
    click_link '연차 정보'
    click_link '연차 항목'

    assert(page.has_content?('휴가'))
    assert(page.has_content?('병원 치료'))
    assert(page.has_content?('기타'))
  end

  test 'should create a new vacation_type' do
    visit '/'
    click_link '연차 정보'
    click_link '연차 항목'
    click_link '신규 작성'

    fill_in '항목', with: '항목 신규 작성'

    click_button '항목 만들기'

    assert(page.has_content?('항목이(가) 성공적으로 생성되었습니다.'))
    assert(page.has_content?('항목 신규 작성'))
  end

  test 'should edit vacation_type' do
    visit '/'
    click_link '연차 정보'
    click_link '연차 항목'
    click_link '상세보기'
    click_link '수정하기'

    fill_in '항목', with: '항목 수정하기'

    click_button '항목 수정하기'

    assert(page.has_content?('항목이(가) 성공적으로 업데이트 되었습니다.'))
    assert(page.has_content?('항목 수정하기'))
  end

  test 'should destroy vacation_type' do
    visit '/'
    click_link '연차 정보'
    click_link '연차 항목'
    click_link '상세보기'

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('휴가'))
    assert(page.has_content?('병원 치료'))
    assert(page.has_content?('기타'))
  end
end