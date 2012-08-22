require 'test_helper'

class CardbillsControllerTest < ActionController::TestCase
  fixtures :cardbills
  fixtures :permissions
  fixtures :people_permissions
  fixtures :card_approved_sources
  fixtures :card_used_sources

  test "should index document list" do
    get :index
    assert_response :success
  end

  test "should show new document form" do
    get :new
    assert_response :success
  end

  test "should show document" do
    Person.current_person = people(:fixture)

    get :show, :id => current_cardbill.id
    assert_response :success
    assert_select '.box #descr #show_command a', 2
    assert_select '.box #descr #show_command', "#{I18n.t('cardbills.show.to_use')}" + " | " + "#{I18n.t('cardbills.show..to_approved')}"
  end

  test "should edit document" do
    get :edit, :id => current_cardbill.id
    assert_response :success
  end

  private
  def current_cardbill
    @cardbill ||= cardbills(:has_permission_cardbill)
  end

  def current_admin
    @admin ||= people(:fixture)
  end
end
