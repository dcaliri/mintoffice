# encoding: UTF-8
require 'test_helper'

class PromissoryTest < ActionDispatch::IntegrationTest
  fixtures :promissories

  test 'should visit Promissory list' do
    visit '/'
    click_link '은행계좌 목록'

    assert(page.has_content?('₩10,000,000'))
    assert(page.has_content?(get_now_time))
  end

  test 'should show Promissory' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('promissories').click_link('상세보기')

    assert(page.has_content?('₩10,000,000'))
    assert(page.has_content?(get_now_time))
  end

  test 'should create a new Promissory' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('promissories').click_link '신규 작성'

    select '2013', from: 'promissory_expired_at_1i'
    select '1월', from: 'promissory_expired_at_2i'
    select '11', from: 'promissory_expired_at_3i'

    select '2012', from: 'promissory_published_at_1i'
    select '3월', from: 'promissory_published_at_2i'
    select '13', from: 'promissory_published_at_3i'

    fill_in '금액', with: '50000'

    click_button '어음 만들기'

    assert(page.has_content?('₩50,000'))
    assert(page.has_content?('2013-01-11'))
    assert(page.has_content?('2012-03-13'))
  end

  test 'should edit Promissory' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('promissories').click_link('상세보기')
    click_link '수정하기'
    
    select '2014', from: 'promissory_expired_at_1i'
    select '11월', from: 'promissory_expired_at_2i'
    select '1', from: 'promissory_expired_at_3i'

    select '2011', from: 'promissory_published_at_1i'
    select '12월', from: 'promissory_published_at_2i'
    select '2', from: 'promissory_published_at_3i'

    fill_in '금액', with: '60000'

    click_button '어음 수정하기'

    assert(page.has_content?('₩60,000'))
    assert(page.has_content?('2014-11-01'))
    assert(page.has_content?('2011-12-02'))
  end

  test 'should destroy Promissory' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('promissories').click_link('상세보기')

    disable_confirm_box

    click_link '삭제하기'
    
    assert(!page.has_content?('₩10,000,000'))
    assert(!page.has_content?(get_now_time))
  end  

  test 'should click list link in promissory' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('promissories').click_link('상세보기')

    click_link '목록'
    
    assert(page.has_content?('₩10,000,000'))
    assert(page.has_content?(get_now_time))
  end  
end