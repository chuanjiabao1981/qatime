require 'test_helper'

module LiveStudio
  class VideoCoursesControllerTest < ActionController::TestCase
    setup do
      @video_course = live_studio_video_courses(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:video_courses)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create video_course" do
      assert_difference('VideoCourse.count') do
        post :create, video_course: { description: @video_course.description, grade: @video_course.grade, name: @video_course.name }
      end

      assert_redirected_to video_course_path(assigns(:video_course))
    end

    test "should show video_course" do
      get :show, id: @video_course
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @video_course
      assert_response :success
    end

    test "should update video_course" do
      patch :update, id: @video_course, video_course: { description: @video_course.description, grade: @video_course.grade, name: @video_course.name }
      assert_redirected_to video_course_path(assigns(:video_course))
    end

    test "should destroy video_course" do
      assert_difference('VideoCourse.count', -1) do
        delete :destroy, id: @video_course
      end

      assert_redirected_to video_courses_path
    end
  end
end
