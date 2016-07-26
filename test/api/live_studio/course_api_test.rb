require 'test_helper'

class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  test "get courses list of teacher" do
    teacher = users(:teacher1)
    get "/api/v1/live_studio/teachers/#{teacher.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
  end

  test "get courses list full of teacher" do
    teacher = users(:teacher1)

    get "/api/v1/live_studio/teachers/#{teacher.id}/courses/full", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
    assert_equal true, res['data'].first.has_key?('lessons')
  end

  test "get course detail of teacher" do
    teacher = users(:teacher1)
    course = teacher.live_studio_courses.last

    get "/api/v1/live_studio/teachers/#{teacher.id}/courses/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 9, res['data'].size
    assert_equal true, res['data'].has_key?('lessons')
  end
end
