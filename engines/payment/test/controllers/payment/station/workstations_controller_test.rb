require 'test_helper'

module Payment
  class Station::WorkstationsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get earning_records" do
      get :earning_records
      assert_response :success
    end

  end
end
