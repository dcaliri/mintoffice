# encoding: UTF-8
require 'test_helper'

class AccessorsControllerTest < ActionController::TestCase
  fixtures :access_people
  fixtures :reports
  fixtures :documents

  test "should create accessor" do
    request.env["HTTP_REFERER"] = document_path(current_document.id)

    post :create, accessor: 'person-2', resources_type: current_target.class.to_s, resources_id: current_target.id, access_type: 'write'
    assert_response :redirect

    assert_equal flash[:notice], I18n.t('controllers.accessors.set_permission')

    request.env["HTTP_REFERER"] = document_path(current_document.id)

    # post :create, accessor: 'person-15', resources_type: current_target.class.to_s, resources_id: current_target.id, access_type: 'write'
    # assert_response :redirect

    # assert_equal flash[:notice], I18n.t('controllers.accessors.set_permission')
  end

  test "should destroy accessor" do
    request.env["HTTP_REFERER"] = document_path(current_document.id)

    post :destroy, accessor_id: current_person.id
    assert_response :redirect

    assert_equal flash[:notice], I18n.t('controllers.accessors.delete_permission')

    # request.env["HTTP_REFERER"] = document_path(current_document.id)

    # post :destroy, accessor_id: 175
    # assert_response :redirect

    # assert_equal flash[:notice], I18n.t('controllers.accessors.delete_permission')
  end

  private
  def current_person
    @current_person ||= people(:normal)
  end

  def current_document
    @current_document ||= documents(:fixture)
  end

  def current_target
    @current_target ||= reports(:admin_expense_report_bank_transfer)
  end
end
