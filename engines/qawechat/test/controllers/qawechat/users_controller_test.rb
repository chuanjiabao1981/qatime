require 'test_helper'

module Qawechat
  class UsersControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should get create" do
      get :create
      assert_response :success
    end

    test "should get show" do
      get :show
      assert_response :success
    end

  end
end
