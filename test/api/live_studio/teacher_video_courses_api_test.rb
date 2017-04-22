require 'test_helper'

class Qatime::TeacherVideoCoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 我的视频课
  test 'teacher video courses list' do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/video_courses", {}, 'Remember-Token' => @remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 7, res['data'].count, '我的视频课数量不正确'

    get "/api/v1/live_studio/teachers/#{@teacher.id}/video_courses", { status: :unpublished }, 'Remember-Token' => @remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 4, res['data'].count, '(未发布)我的视频课数量不正确'

    get "/api/v1/live_studio/teachers/#{@teacher.id}/video_courses", { status: :published }, 'Remember-Token' => @remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 3, res['data'].count, '(已发布)我的视频课数量不正确'
  end

end
