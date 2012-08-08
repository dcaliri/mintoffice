# encoding: UTF-8
require 'test_helper'

class AttachmentTest < ActionDispatch::IntegrationTest

  test 'should visit attachment list' do
    visit '/'
    click_link '첨부파일 관리'

    assert(page.has_content?('첨부파일'))
  end
end