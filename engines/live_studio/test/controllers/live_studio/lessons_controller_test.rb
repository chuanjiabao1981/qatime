require 'test_helper'

module LiveStudio
  class LessonsControllerTest < ActionController::TestCase
    setup do
      @lesson = live_studio_lessons(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:lessons)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create lesson" do
      assert_difference('Lesson.count') do
        post :create, lesson: { name: @lesson.name }
      end

      assert_redirected_to lesson_path(assigns(:lesson))
    end

    test "should show lesson" do
      get :show, id: @lesson
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @lesson
      assert_response :success
    end

    test "should update lesson" do
      patch :update, id: @lesson, lesson: { name: @lesson.name }
      assert_redirected_to lesson_path(assigns(:lesson))
    end

    test "should destroy lesson" do
      assert_difference('Lesson.count', -1) do
        delete :destroy, id: @lesson
      end

      assert_redirected_to lessons_path
    end
  end
end
