# encoding: UTF-8
require 'test_helper'

class EmptyTaxBillCreateTest < ActionDispatch::IntegrationTest

  test 'should create a new taxbill' do
    visit '/'
    click_link '세금계산서 관리'
    click_link '신규 작성'
    
    page.driver.browser.switch_to.alert.accept

    assert(page.has_content?('세금계산서 관리'))
  end
end