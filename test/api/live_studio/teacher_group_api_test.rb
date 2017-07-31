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
    assert_equal 9, @res['data'].count, "我的专属课数量不正确"
  end
end
