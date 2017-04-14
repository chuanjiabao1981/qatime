require 'test_helper'

class Qatime::StudentVideoCoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  # 我的视频课
  test 'student video courses list' do
    get "/api/v1/live_studio/students/#{@student.id}/video_courses", {}, 'Remember-Token' => @student_remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 2, res['data'].count, '我的视频课数量不正确'

    get "/api/v1/live_studio/students/#{@student.id}/video_courses", { sell_type: :charge }, 'Remember-Token' => @student_remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '(已购)我的视频课数量不正确'

    get "/api/v1/live_studio/students/#{@student.id}/video_courses", { sell_type: :free }, 'Remember-Token' => @student_remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '(免费)我的视频课数量不正确'
  end

end
