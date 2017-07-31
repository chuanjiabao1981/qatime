require 'test_helper'

class Qatime::StudentGroupAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)
  end

  # 我的专属课
  test "student groups list" do
    get "/api/v1/live_studio/students/#{@student.id}/customized_groups?status=published", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_equal 2, @res['data'].count, "我的专属课数量不正确"
  end
end
