# encoding: UTF-8
require 'test_helper'

class InvestmentTest < ActionDispatch::IntegrationTest
  fixtures :investments
  fixtures :investment_estimations

  test 'should visit investment list' do
    visit '/'
    click_link '은행계좌 목록'

    assert(page.has_content?('금융투자'))
    assert(page.has_content?('₩1,000,000'))
    assert(page.has_content?('₩500,000'))
  end

  test 'should show investment' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')

    assert(page.has_content?('금융투자'))
    assert(page.has_content?('주식거래'))
  end

  test 'should create a new investment' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('신규 작성')

    fill_in '자산명', with: '자산명 입력 테스트'
    fill_in '상세정보', with: '상세정보 입력 테스트'

    click_button '투자자산 만들기'

    assert(page.has_content?('자산명 입력 테스트'))
    assert(page.has_content?('상세정보 입력 테스트'))
  end

  test 'should edit investment' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')
    click_link '수정하기'

    fill_in '자산명', with: '자산명 수정 테스트'
    fill_in '상세정보', with: '상세정보 수정 테스트'

    click_button '투자자산 수정하기'

    assert(page.has_content?('자산명 수정 테스트'))
    assert(page.has_content?('상세정보 수정 테스트'))
  end

  test 'should destroy investment' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('금융투자'))
  end

  test 'should create a new estimation' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')
    click_link '신규 작성'

    fill_in '평가액', with: '3000000'
    select "#{Time.zone.now.year}", from: 'investment_estimation_estimated_at_1i'
    select "#{Time.zone.now.month}월", from: 'investment_estimation_estimated_at_2i'
    select "#{Time.zone.now.day}", from: 'investment_estimation_estimated_at_3i'

    click_button '투자자산 평가액 만들기'

    assert(page.has_content?('₩1,000,000'))
    assert(page.has_content?('₩3,000,000'))
    assert(page.has_content?(get_now_time))
  end

  test 'should edit estimation' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')
    find('#list-table').click_link('수정하기')

    fill_in '평가액', with: '500000'
    select "2011", from: 'investment_estimation_estimated_at_1i'
    select "2월", from: 'investment_estimation_estimated_at_2i'
    select "13", from: 'investment_estimation_estimated_at_3i'

    click_button '투자자산 평가액 수정하기'

    assert(page.has_content?('₩500,000'))
    assert(page.has_content?('2011-02-13'))
  end

  test 'should destroy estimation' do
    visit '/'
    click_link '은행계좌 목록'
    find_by_id('investments').click_link('상세보기')

    disable_confirm_box

    find('#list-table').click_link('삭제하기')
    
    assert(!page.has_content?('₩1,000,000'))
    assert(page.has_content?('₩500,000'))
  end
end