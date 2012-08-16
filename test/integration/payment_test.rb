# encoding: UTF-8
require 'test_helper'

class PaymentTest < ActionDispatch::IntegrationTest
  fixtures :payments

  test 'should show a new payment in 9 month' do
    visit '/payments/2'
    click_link '기본급 작성'

    select "#{Time.zone.now.year}", from: 'payments_join_at_1i'
    select '8월', from: 'payments_join_at_2i'
    select '21', from: 'payments_join_at_3i'

    select "#{Time.zone.now.year}", from: 'payments_pay_finish_1i'
    select '8월', from: 'payments_pay_finish_2i'
    select '29', from: 'payments_pay_finish_3i'

    fill_in "금액", with: "1500000"

    click_button '추가하기'
    click_button '추가하기'

    assert(!page.has_content?('2012.08'))
    assert(page.has_content?('2012.09'))
    assert(!page.has_content?('08.29'))
    assert(page.has_content?('09.20'))
  end
end