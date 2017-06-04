require 'test_helper'

class Qatime::CourseAnnouncementsAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  test "publish course announcement" do
    course = @teacher.live_studio_courses.last
    stub_chat_account
    assert_difference "course.announcements.count", 1, "教师发布公告失败" do
      post "/api/v1/live_studio/courses/#{course.id}/announcements", { content: "发个公告试试" }, 'Remember-Token' => @remember_token
      assert_response :success
      res = JSON.parse(response.body)
      assert_equal 1, res['status'], "返回状态不正确#{res}"
    end
  end
end
