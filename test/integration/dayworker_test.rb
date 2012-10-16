# encoding: UTF-8
require 'test_helper'

class DayWorkerTest < ActionDispatch::IntegrationTest
  fixtures :dayworkers
  fixtures :bankbooks

  test 'should visit dayworker list' do
    visit '/dayworkers'

    assert(page.has_content?('111111-1111111'))
  end

  test 'should show dayworker' do
    visit '/dayworkers'
    click_link '상세보기'
    
    assert(page.has_content?('111111-1111111'))
    assert(page.has_content?('HSBC 통장'))
  end

  test 'should create a new dayworker' do
    visit '/dayworkers'
    click_link '신규 작성'

    fill_in '주민등록번호', with: '222222-2222222'
    select '농협 통장', from: 'dayworker_bankbook_id'

    click_button '생성'

    assert(page.has_content?('222222-2222222'))
    assert(page.has_content?('농협 통장'))
  end

  test 'should create a new dayworker with empty bankbook' do
    visit '/dayworkers'
    click_link '신규 작성'

    fill_in '주민등록번호', with: '222222-2222222'
    select '없음', from: 'dayworker_bankbook_id'

    click_button '생성'

    assert(page.has_content?('222222-2222222'))
  end

  test 'should edit dayworker' do
    visit '/dayworkers'
    click_link '상세보기'
    click_link '수정하기'

    fill_in '주민등록번호', with: '222222-2222222'
    select '농협 통장', from: 'dayworker_bankbook_id'

    click_button '수정'

    assert(page.has_content?('222222-2222222'))
    assert(page.has_content?('농협 통장'))
  end  
end