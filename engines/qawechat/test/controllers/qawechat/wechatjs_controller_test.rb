require 'test_helper'

module Qawechat
  class WechatjsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get test" do
      get :test
      assert_response :success
    end

  end
end
