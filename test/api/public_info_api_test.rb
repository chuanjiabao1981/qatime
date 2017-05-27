require 'test_helper'
class Qatime::PublicInfoAPITest < ActionDispatch::IntegrationTest
  test "GET /api/v1/teachers/:id/profile" do
    teacher = users(:teacher_for_taste_course)
    get "/api/v1/teachers/#{teacher.id}/profile"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 15, res['data'].count, "返回结果不正确 #{res}"
  end
end
