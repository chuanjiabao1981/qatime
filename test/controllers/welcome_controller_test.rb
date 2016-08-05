require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get download" do
    get :download
    assert_response :success
  end

end
