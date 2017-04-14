require 'test_helper'

module LiveStudio
  class Teacher::VideoCoursesControllerTest < ActionController::TestCase
    setup do
      @teacher_video_course = live_studio_teacher_video_courses(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:teacher_video_courses)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create teacher_video_course" do
      assert_difference('Teacher::VideoCourse.count') do
        post :create, teacher_video_course: { description: @teacher_video_course.description, grade: @teacher_video_course.grade, name: @teacher_video_course.name }
      end

      assert_redirected_to teacher_video_course_path(assigns(:teacher_video_course))
    end

    test "should show teacher_video_course" do
      get :show, id: @teacher_video_course
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @teacher_video_course
      assert_response :success
    end

    test "should update teacher_video_course" do
      patch :update, id: @teacher_video_course, teacher_video_course: { description: @teacher_video_course.description, grade: @teacher_video_course.grade, name: @teacher_video_course.name }
      assert_redirected_to teacher_video_course_path(assigns(:teacher_video_course))
    end

    test "should destroy teacher_video_course" do
      assert_difference('Teacher::VideoCourse.count', -1) do
        delete :destroy, id: @teacher_video_course
      end

      assert_redirected_to teacher_video_courses_path
    end
  end
end
