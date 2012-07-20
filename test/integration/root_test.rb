# encoding: UTF-8
require 'test_helper'

class RootTest < ActionDispatch::IntegrationTest
  test 'show visit root page' do
    assert(page.has_content?('Mint Office'))
  end
end