require 'test_helper'

class CardUsedSourcesControllerTest < ActionController::TestCase
  def setup
    current_user.permission.create!(name: 'card_used_sources')
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see show page" do
    get :show, id: current_card_used_source.id
    assert_response :success
  end

  test "should see new page" do
    get :new, id: current_card_used_source.id
    assert_response :success
  end

  test "should see edit page" do
    get :edit, id: current_card_used_source.id
    assert_response :success
  end

  private
  def current_creditcard
    @creditcard ||= Creditcard.create!({
      cardno: 1,
      expireyear: 1,
      expiremonth: 1,
      nickname: 1,
      issuer: 1,
      cardholder: 1,
    })
  end

  def current_card_used_source
    @card_used_source ||= current_creditcard.card_used_sources.create!(approve_no: "1234")
  end
end