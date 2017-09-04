require 'test_helper'

class Qatime::TeacherGroupAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 我的专属课
  test "teacher groups list" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/customized_groups?status=published,teaching", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_equal 12, @res['data'].count, "我的专属课数量不正确"
  end

  # 专属课 发布公告
  test "teacher groups announcements" do
    group = @teacher.live_studio_customized_groups.last
    post "/api/v1/live_studio/customized_groups/#{group.id}/announcements", {content: '测试公告'}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_equal 'ok', @res['data']
    assert_equal '测试公告', group.announcements.last.content, '公告发送失败'
  end
end
