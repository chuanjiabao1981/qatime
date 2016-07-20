require 'test_helper'

class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  test "get courses list of teacher" do
    teacher = users(:teacher1)
    remember_token = teacher.login_tokens.first.remember_token

    get '/api/v1/live_studio/teacher/courses', {}, { 'Remember-Token': remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
  end

  test "get courses list full of teacher" do
    teacher = users(:teacher1)
    remember_token = teacher.login_tokens.first.remember_token

    get '/api/v1/live_studio/teacher/courses/full', {}, { 'Remember-Token': remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
    assert_equal true, res['data'].first.has_key?('lessons')
  end

  test "get course detail of teacher" do
    teacher = users(:teacher1)
    course = teacher.live_studio_courses.last
    remember_token = teacher.login_tokens.first.remember_token

    get "/api/v1/live_studio/teacher/courses/#{course.id}", {}, { 'Remember-Token': remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 8, res['data'].size
    assert_equal true, res['data'].has_key?('lessons')
  end
end
