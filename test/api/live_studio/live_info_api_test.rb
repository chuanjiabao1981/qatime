require 'test_helper'

class Qatime::LiveInfoAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  test "get courses live status" do
    today_course = live_studio_courses(:course_teaching2)
    finished_course = live_studio_courses(:course_finished)
    unstart_course = live_studio_courses(:course_preview2)
    courses = [today_course, finished_course, unstart_course]
    get "/api/v1/live_studio/status", params: { course_ids: courses.map(&:id).join('-') }, headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 3, res['data'].size
    assert_equal %w(init ready closed), res['data'].map(&:second)
  end

  test "get lessons live status" do
    lessons = LiveStudio::Lesson.today.readied
    get "/api/v1/live_studio/status", params: { lesson_ids: lessons.map(&:id).join('-') }, headers: { 'Remember-Token' => @student_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal lessons.map {|l| [l.id, l.status] }, res['data']
  end

  test "get course live info" do
    today_course = live_studio_courses(:course_teaching2)
    get "/api/v1/live_studio/courses/#{today_course.id}/status", params: {}, headers: { 'Remember-Token' => @student_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应错误 #{res}"
    assert_equal 'ready', res['data']['live_info']['status']
  end
end
