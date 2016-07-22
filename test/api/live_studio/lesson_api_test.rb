require 'test_helper'
class Qatime::LessonAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  def data
    JSON.parse(response.body)['data']
  end

  def get_url(url, params)
    teacher = users(:teacher1)
    token = teacher.login_tokens.first.remember_token
    url['teacher_id'] = teacher.id.to_s
    get url, params, {'Remember-Token' => token }
  end

  test 'GET /api/v1/live_studio/teacher/live_start' do
    lesson = live_studio_lessons(:ready_lesson_today)
    get_url("/api/v1/live_studio/teachers/teacher_id/live_start",{lesson_id: lesson.id})
    assert_response :success
    assert data.length == 32
  end

  test 'GET /api/v1/live_studio/teacher/heartbeat' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url('/api/v1/live_studio/teachers/teacher_id/heartbeat', {lesson_id: lesson.id})
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    token = data
    get_url('/api/v1/live_studio/teachers/teacher_id/heartbeat', {lesson_id: lesson.id, token: token})
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    assert data == token, '应该和之前的token一致'
  end

  test 'GET //api/v1/live_studio/teacher/live_end' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url('/api/v1/live_studio/teachers/teacher_id/live_end', {lesson_id: lesson.id})
    assert_response :success
    assert data, '没有正确返回true'
  end
end