# encoding: UTF-8
require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  fixtures :enrollments

  setup do
    @valid_attributes = {
      juminno: "120101-1111112",
      company_id: 1,
      person_id: 11
    }

    @invalid_attribute1 = {
      juminno: "1234567-123456",
      company_id: 1,
      person_id: 11
    }

    @invalid_attribute2 = {
      juminno: "120101-1111111",
      company_id: 1,
      person_id: 11
    }
  end

  test "Enrollment should create enrollment with valid attributes" do
    enrollment = Enrollment.new(@valid_attributes)
    assert enrollment.valid?
  end

  #test "Enrollment shouldn't create enrollment with invalid attributes" do    
  #  enrollment = Enrollment.find(current_enrollment.id)
  #  assert_false enrollment.update_attributes!(@invalid_attribute1)
  #
  #  enrollment = Enrollment.find(current_enrollment.id)
  #  assert_false enrollment.update_attributes!(@invalid_attribute2)
  #end

  private
  def current_enrollment
    @enrollment ||= enrollments(:fixture)
  end
end