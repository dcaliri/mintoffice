# encoding: UTF-8
require 'test_helper'

class RootTest < ActionDispatch::IntegrationTest
  setup do
    logout
  end

  test 'show visit login page if logged out' do
    visit '/'
    assert(page.has_content?('로그인'))
  end

  test 'show visit root page' do
    login
    assert(page.has_content?('Mint Office'))
  end
end