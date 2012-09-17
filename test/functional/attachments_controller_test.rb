# encoding: UTF-8
require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  fixtures :attachments

  setup do
    @valid_attributes = {
      title: '',
		  comments: '',
		  filepath: 'seal.png'
    }

    @invalid_attributes = {
      title: '',
		  comments: '',
		  filepath: ''
    }
  end

  test "should see index page" do
    get :index
    assert_response :success
  end

  test "should see show page" do
    get :show, id: current_attachment.id
    assert_response :success
  end

  # test "should download this attachment file" do
  # 	get :show, id: current_attachment.id
  #   assert_response :success

  #   post :download, id: current_attachment.id
  #   assert_response :success
  # end

  # test "should fail to download this attachment file" do
  #   post :download, id: current_attachment.id
  #   assert_response :redirect

  #   assert_equal flash[:notice], I18n.t("permissions.permission_denied")
  # end

  # test "should show and download picture" do
  # 	get :show, id: current_attachment.id
  #   assert_response :success

  #   post :picture, id: current_attachment.id, w: '600', h: '800'
  #   assert_response :success

  #   post :picture, id: current_attachment.id
  #   assert_response :success
  # end

  # test "should fail to show and download picture" do
  #   post :picture, id: current_attachment.id, w: '600', h: '800'
  #   assert_response :redirect

  #   assert_equal flash[:notice], I18n.t("permissions.permission_denied")

  #   post :picture, id: current_attachment.id
  #   assert_response :redirect

  #   assert_equal flash[:notice], I18n.t("permissions.permission_denied")
  # end

  test "should see new page" do
    get :new
    assert_response :success
  end

	test "should save data" do
    post :save, attachment: @valid_attributes
    assert_response :redirect

    assert_equal flash[:notice], I18n.t("common.messages.created", :model => Attachment.model_name.human)
  end

  test "should fail to save data" do
    post :save, attachment: @invalid_attributes
    assert_response :success
  end

	test "should see edit page" do
    get :edit, id: current_attachment.id
    assert_response :success
  end

  test "should create attachment" do
    post :create, attachment: @valid_attributes
    assert_response :redirect
  end

  test "should fail to create attachment" do
    post :create, attachment: @invalid_attributes
    assert_response :success
  end

  test "should update attachment" do
    post :update, id: current_attachment.id, attachment: @valid_attributes
    assert_response :redirect
  end

  test "should destroy attachment" do
    post :destroy, id: current_attachment.id
    assert_response :redirect
  end

  test "should delete attachment" do
  	request.env["HTTP_REFERER"] = company_path(1)
    session[:return_to] = request.referer

    post :delete, id: current_attachment.id
    assert_response :redirect
  end

  private
  def current_attachment
    @current_attachment ||= attachments(:seal)
  end
end
