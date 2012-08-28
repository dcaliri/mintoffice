# encoding: UTF-8
require 'test_helper'

class CommuteTest < ActionDispatch::IntegrationTest
  test 'should visit my commute' do
    visit '/'
    click_link '출퇴근 관리'

    assert(page.has_content?('출퇴근 기록 관리'))
  end

  test 'should visit commute list' do
    visit '/'
    click_link '출퇴근 관리'

    assert(page.has_content?('출퇴근 기록 관리'))

    click_link '목록'

    assert(page.has_content?('목록'))

    click_link '한 주 전으로'

    assert(page.has_content?('한 주 이후로'))

    click_link '한 주 이후로'

    assert(!page.has_content?('한 주 이후로'))
  end
end