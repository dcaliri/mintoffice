require 'test_helper'

class CardApprovedSourcesControllerTest < ActionController::TestCase
  def setup
    current_user.permission.create!(name: 'card_approved_sources')
  end

  test "should see list of card approved sourcepage" do
    get :index
    assert_response :success
  end

  test "should see card approved source page" do
    get :show, id: current_card_approved_source.id
    assert_response :success
  end

  test "should see new card approved source page" do
    get :new, id: current_card_approved_source.id
    assert_response :success
  end

  test "should see edit card approved source page" do
    get :edit, id: current_card_approved_source.id
    assert_response :success
  end

  test "should see find empty cardbills card page" do
    get :find_empty_cardbills
    assert_response :success
  end

  test "should see generate cardbills page" do
    get :generate_cardbills, owner: current_user.id
    assert_response :redirect
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

  def current_card_approved_source
    @card_approved_source ||= current_creditcard.card_approved_sources.create!(approve_no: "1234")
  end
end