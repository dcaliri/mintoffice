require 'test_helper'

class CardUsedSourcesControllerTest < ActionController::TestCase
  fixtures :creditcards
  fixtures :card_used_sources

  def setup
    current_account.employee.permission.create!(name: 'card_used_sources')
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

  test "should export card used source" do
    post :export, id: current_card_used_source.id, to: :pdf
    assert_response :success
  end

  private
  def current_creditcard
    @creditcard ||= creditcards(:fixture)
  end

  def current_card_used_source
    @card_used_source ||= card_used_sources(:fixture)
  end
end