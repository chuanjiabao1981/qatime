require 'test_helper'

module Recommend
  class Admin::ItemsControllerTest < ActionController::TestCase
    setup do
      @admin_item = recommend_admin_items(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:admin_items)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create admin_item" do
      assert_difference('Admin::Item.count') do
        post :create, admin_item: { title: @admin_item.title }
      end

      assert_redirected_to admin_item_path(assigns(:admin_item))
    end

    test "should show admin_item" do
      get :show, id: @admin_item
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @admin_item
      assert_response :success
    end

    test "should update admin_item" do
      patch :update, id: @admin_item, admin_item: { title: @admin_item.title }
      assert_redirected_to admin_item_path(assigns(:admin_item))
    end

    test "should destroy admin_item" do
      assert_difference('Admin::Item.count', -1) do
        delete :destroy, id: @admin_item
      end

      assert_redirected_to admin_items_path
    end
  end
end
