# require 'test_helper'
#
# class DayworkerTaxesControllerTest < ActionController::TestCase
#   fixtures :dayworkers, :dayworker_taxes
#
#   def setup
#     current_user.permission.create!(name: 'dayworker_taxes')
#   end
#
#   test "should see index page" do
#     get :index
#     assert_response :success
#   end
#
#   test "should see new page" do
#     get :new
#     assert_response :success
#   end
#
#   test "should see show page" do
#     get :show, :id => current_dayworker_tax.id
#     assert_response :success
#   end
#
#   test "should see edit page" do
#     get :edit, :id => current_dayworker_tax.id
#     assert_response :success
#   end
#
#   private
#   def current_dayworker_tax
#     @dayworker_tax ||= dayworker_taxes(:fixture)
#   end
# end
