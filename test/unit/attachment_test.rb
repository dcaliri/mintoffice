# encoding: UTF-8
require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      title: "test attachment",
      comments: "test",
      filepath: "Untitled.xls",
      contenttype: "application/vnd.ms-excel",
      owner_type: "Document",
      owner_id: 1,
      original_filename: "Untitled.png",
      employee_id: 1
    }
  end

  test "Attachment should create attachment with valid attributes" do
    attachment = Attachment.new(@valid_attributes)
    assert attachment.valid?
  end

  test "Attachment shouldn't create attachment with invalid attributes" do
    attachment = Attachment.new(@valid_attributes)
    attachment.filepath = nil
    assert attachment.invalid?
  end
end