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
  end

  test "Enrollment should create enrollment with valid attributes" do
    enrollment = Enrollment.new(@valid_attributes)
    assert enrollment.valid?
  end

  test "Enrollment shouldn't create enrollment with invalid attributes" do    
    enrollment = Enrollment.create!(@valid_attributes)
    enrollment.juminno = "1234567-123456"
    assert enrollment.invalid?
  
    enrollment = Enrollment.create!(@valid_attributes)
    enrollment.juminno = "120101-1111111"
    assert enrollment.invalid?
  end
end