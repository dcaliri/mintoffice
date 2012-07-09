require 'test_helper'

class CommutesControllerTest < ActionController::TestCase
  fixtures :commutes

  def setup
    current_user.permission.create!(name: 'commutes')
  end

  test "should see index page" do
    get :index, user_id: 1
    assert_response :success
  end

  test "should see show page" do
    get :show, user_id: 1, :id => current_commute.id
    assert_response :success
  end

  test "should see detail page" do
    get :detail, user_id: 1, :id => current_commute.id
    assert_response :success
  end

  test "commute can't duplicated between the day" do
    user = User.first
    morning = Time.now.change(hour: 8)

    before = user.commutes.build(go: morning)
    before.save!

    after = user.commutes.build(go: morning)
    assert after.invalid?
  end

  private
  def current_commute
    @commute ||= commutes(:fixture)
  end
end
