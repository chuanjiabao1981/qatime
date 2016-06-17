require 'test_helper'

module LiveStudio
  class CoursesControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get teate" do
      get :teate
      assert_response :success
    end

  end
end
