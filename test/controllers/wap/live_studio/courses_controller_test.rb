require 'test_helper'

class Wap::LiveStudio::CoursesControllerTest < ActionController::TestCase
  setup do
    @wap_live_studio_course = wap_live_studio_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wap_live_studio_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wap_live_studio_course" do
    assert_difference('Wap::LiveStudio::Course.count') do
      post :create, wap_live_studio_course: {  }
    end

    assert_redirected_to wap_live_studio_course_path(assigns(:wap_live_studio_course))
  end

  test "should show wap_live_studio_course" do
    get :show, id: @wap_live_studio_course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wap_live_studio_course
    assert_response :success
  end

  test "should update wap_live_studio_course" do
    patch :update, id: @wap_live_studio_course, wap_live_studio_course: {  }
    assert_redirected_to wap_live_studio_course_path(assigns(:wap_live_studio_course))
  end

  test "should destroy wap_live_studio_course" do
    assert_difference('Wap::LiveStudio::Course.count', -1) do
      delete :destroy, id: @wap_live_studio_course
    end

    assert_redirected_to wap_live_studio_courses_path
  end
end
