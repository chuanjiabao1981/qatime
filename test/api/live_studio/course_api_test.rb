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

  test "GET /api/v1/live_studio/teacher/courses returns teacher's courses list" do
    get '/api/v1/live_studio/teacher/courses'
    assert_response :success
    assert_equal [], JSON.parse(last_response.body)
  end
  def data
    JSON.parse(response.body)['data']
  end

  test 'GET /api/v1/live_studio/teacher/live_start' do
    lesson = live_studio_lessons(:ready_lesson_today)
    get '/api/v1/live_studio/teacher/live_start?lesson_id=%d' % lesson.id
    assert_response :success
    assert data.length == 32
  end

  test 'GET /api/v1/live_studio/teacher/heartbeat' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get '/api/v1/live_studio/teacher/heartbeat?lesson_id=%d' % lesson.id
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    token = data
    get '/api/v1/live_studio/teacher/heartbeat?lesson_id=%d&token=%s' % [lesson.id, token]
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    assert data == token, '应该和之前的token一致'
  end

  test 'GET /api/v1/live_studio/teacher/live_end' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get '/api/v1/live_studio/teacher/live_end?lesson_id=%d' % lesson.id
    assert_response :success
    assert data, '没有正确返回true'
  end
end
