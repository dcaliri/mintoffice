# encoding: UTF-8
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects

  setup do
    @valid_attributes = {
      name: "test project",
      started_on: "2012-07-18",
      ending_on: "2012-07-18",
      ended_on: nil,
      revenue: 2000000,
      company_id: 1
    }
  end

  test "Project should create project with valid attributes" do
    project = Project.new(@valid_attributes)
    assert project.valid?
  end

  test "Project shouldn't create project with invalid attributes" do
    project = Project.new(@valid_attributes)
    project.name = "테스트 프로젝트"
    assert project.invalid?

    project = Project.new(@valid_attributes)
    project.revenue = "none_numericality"
    assert project.invalid?
  end
end