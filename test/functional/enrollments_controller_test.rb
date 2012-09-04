# encoding: UTF-8
require 'test_helper'

class SectionEnrollment::EnrollmentsControllerTest < ActionController::TestCase
  fixtures :enrollments
  fixtures :enrollment_items

  test "should see dashboard page" do
    get :dashboard
    assert_response :success
  end

  test "should see edit page" do
    get :edit, :id => current_enrollment.id
    assert_response :success
  end

  test "should see attch_item page" do
    get :attach_item, :id => current_enrollment.id, :name => current_enrollment_item.name
    assert_response :success
  end

  private
  def current_enrollment
    @enrollment ||= enrollments(:fixture)
  end

  def current_enrollment_item
    @enrollment_item ||= enrollment_items(:fixture)
  end
end
