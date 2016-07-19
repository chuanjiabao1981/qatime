require 'test_helper'

class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  test "get courses list of teacher" do
    teacher = users(:teacher1)
    remember_token = teacher.login_tokens.first.remember_token

    get '/api/v1/live_studio/teacher/courses', nil, header('Remember-Token', remember_token)
    assert_response :success
    assert_equal [], JSON.parse(response.body)

  end
end
