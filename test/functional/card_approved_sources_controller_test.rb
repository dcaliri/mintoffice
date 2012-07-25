require 'test_helper'

class CardApprovedSourcesControllerTest < ActionController::TestCase
  fixtures :creditcards
  fixtures :card_approved_sources

  def setup
    current_account.employee.permission.create!(name: 'card_approved_sources')
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
    get :generate_cardbills, owner: current_account.id
    assert_response :redirect
  end

  test "should export card approved source" do
    post :export, id: current_card_approved_source.id, to: :pdf
    assert_response :success
  end

  private
  def current_creditcard
    @creditcard ||= creditcards(:fixture)
  end

  def current_card_approved_source
    @card_approved_source ||= card_approved_sources(:fixture)
  end
end