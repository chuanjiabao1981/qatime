require 'test_helper'

module Chat
  class TeamsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get finish" do
      get :finish
      assert_response :success
    end

  end
end
