require 'test_helper'

module LiveStudio
  class Teacher::LessonsControllerTest < ActionController::TestCase
    setup do
      @teacher_lesson = live_studio_teacher_lessons(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:teacher_lessons)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create teacher_lesson" do
      assert_difference('Teacher::Lesson.count') do
        post :create, teacher_lesson: { class_date: @teacher_lesson.class_date, description: @teacher_lesson.description, end_time: @teacher_lesson.end_time, name: @teacher_lesson.name, start_time: @teacher_lesson.start_time }
      end

      assert_redirected_to teacher_lesson_path(assigns(:teacher_lesson))
    end

    test "should show teacher_lesson" do
      get :show, id: @teacher_lesson
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @teacher_lesson
      assert_response :success
    end

    test "should update teacher_lesson" do
      patch :update, id: @teacher_lesson, teacher_lesson: { class_date: @teacher_lesson.class_date, description: @teacher_lesson.description, end_time: @teacher_lesson.end_time, name: @teacher_lesson.name, start_time: @teacher_lesson.start_time }
      assert_redirected_to teacher_lesson_path(assigns(:teacher_lesson))
    end

    test "should destroy teacher_lesson" do
      assert_difference('Teacher::Lesson.count', -1) do
        delete :destroy, id: @teacher_lesson
      end

      assert_redirected_to teacher_lessons_path
    end
  end
end
