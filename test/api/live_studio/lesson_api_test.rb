require 'test_helper'
class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
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

  test 'GET //api/v1/live_studio/teacher/live_end' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get '/api/v1/live_studio/teacher/live_end?lesson_id=%d' % lesson.id
    assert_response :success
    assert data, '没有正确返回true'
  end
end