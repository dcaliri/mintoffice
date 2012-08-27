# encoding: UTF-8

require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
	fixtures :documents
  fixtures :projects
  fixtures :people
  fixtures :employees
  fixtures :contacts

  test "document should create document" do
  	document = Document.new
    document.title = "new test"
    document.project_id = current_project.id
    assert document.save!
  end

  test "document should update document" do
  	document = Document.find(current_document.id)
    document.title = "update test"
    document.project_id = current_project.id
    assert document.save!
  end

  test "document should destroy document" do
  	document = Document.find(current_document.id)
    assert document.destroy
  end

  test "check report text" do
    def email_notify_title(from)
      "문서관리 - #{from.fullname}의 결재요청"
    end

    def boxcar_notify_title(from, doc)
      "문서관리 - #{from.fullname}의 결재요청 : #{doc.title}"
    end

    def email_notify_body(doc, url, comment)
      <<-BODY
        문서제목 :
        #{doc.title}

        코멘트:
        #{comment}

        링크:
        #{url}
      BODY
    end

    comment_email = "문서관리 - #{current_employee.fullname}의 결재요청"
    assert_equal(comment_email, email_notify_title(current_employee))

    comment_boxcar = "문서관리 - #{current_employee.fullname}의 결재요청 : #{current_document.title}"
    assert_equal(comment_boxcar, boxcar_notify_title(current_employee, current_document))

    comment_email_body = "        문서제목 :\n        테스트 문서\n\n        코멘트:\n        test\n\n        링크:\n        /\n"
    assert_equal(comment_email_body, email_notify_body(current_document, '/', 'test'))
  end

  private
  def current_document
    @document ||= documents(:fixture)
  end

  def current_project
    @project ||= projects(:fixture)
  end

  def current_employee
    @employee ||= employees(:fixture)
  end
end