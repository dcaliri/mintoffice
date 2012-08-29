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
    def email_notify_title(action, doc, from)
      if action == :rollback
        "문서관리 - #{doc.title} - #{from.fullname}님에 의해서 반려되었습니다."
      else
        "문서관리 - #{from.fullname}님이 #{doc.title} 문서를 상신하였습니다."
    end
    end

    def boxcar_notify_title(action, doc, from)
      if action == :rollback
        "문서관리 - #{doc.title} - #{from.fullname}님에 의해서 반려되었습니다."
      else
        "문서관리 - #{from.fullname}의 결재요청 : #{doc.title}"
    end
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

    report_comment_email = "문서관리 - #{current_employee.fullname}님이 #{current_document.title} 문서를 상신하였습니다."
    assert_equal(report_comment_email, email_notify_title(:report, current_document, current_employee))

    rollback_comment_email = "문서관리 - #{current_document.title} - #{current_employee.fullname}님에 의해서 반려되었습니다."
    assert_equal(rollback_comment_email, email_notify_title(:rollback, current_document, current_employee))

    report_comment_boxcar = "문서관리 - #{current_employee.fullname}의 결재요청 : #{current_document.title}"
    assert_equal(report_comment_boxcar, boxcar_notify_title(:report, current_document, current_employee))

    rollback_comment_boxcar = "문서관리 - #{current_document.title} - #{current_employee.fullname}님에 의해서 반려되었습니다."
    assert_equal(rollback_comment_boxcar, boxcar_notify_title(:rollback, current_document, current_employee))

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