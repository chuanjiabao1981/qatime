require 'test_helper'

module LiveStudio
  class Manager::CoursesControllerTest < ActionController::TestCase
    setup do
      @manager_course = live_studio_manager_courses(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:manager_courses)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create manager_course" do
      assert_difference('Manager::Course.count') do
        post :create, manager_course: { name: @manager_course.name }
      end

      assert_redirected_to manager_course_path(assigns(:manager_course))
    end

    test "should show manager_course" do
      get :show, id: @manager_course
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @manager_course
      assert_response :success
    end

    test "should update manager_course" do
      patch :update, id: @manager_course, manager_course: { name: @manager_course.name }
      assert_redirected_to manager_course_path(assigns(:manager_course))
    end

    test "should destroy manager_course" do
      assert_difference('Manager::Course.count', -1) do
        delete :destroy, id: @manager_course
      end

      assert_redirected_to manager_courses_path
    end
  end
end
