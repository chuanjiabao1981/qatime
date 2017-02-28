require 'test_helper'

class Wap::LiveStudio::OrdersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
