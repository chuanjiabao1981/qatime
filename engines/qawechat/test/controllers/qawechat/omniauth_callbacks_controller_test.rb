require 'test_helper'

module Qawechat
  class OmniauthCallbacksControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get wechat" do
      get :wechat
      assert_response :success
    end

  end
end
