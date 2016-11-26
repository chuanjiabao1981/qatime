require 'test_helper'

module LiveStudio
  class AnnouncementsControllerTest < ActionController::TestCase
    setup do
      @announcement = live_studio_announcements(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:announcements)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create announcement" do
      assert_difference('Announcement.count') do
        post :create, announcement: { content: @announcement.content }
      end

      assert_redirected_to announcement_path(assigns(:announcement))
    end

    test "should show announcement" do
      get :show, id: @announcement
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @announcement
      assert_response :success
    end

    test "should update announcement" do
      patch :update, id: @announcement, announcement: { content: @announcement.content }
      assert_redirected_to announcement_path(assigns(:announcement))
    end

    test "should destroy announcement" do
      assert_difference('Announcement.count', -1) do
        delete :destroy, id: @announcement
      end

      assert_redirected_to announcements_path
    end
  end
end
