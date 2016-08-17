require 'test_helper'
class Qatime::LessonAPITest < ActionDispatch::IntegrationTest

  def app
    Rails.application
  end

  def data
    JSON.parse(response.body)['data']['live_token']
  end

  def get_url(url, params)
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
         password: 'password',
         client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get url, params, 'Remember-Token' => @remember_token
  end

  test 'GET /api/v1/live_studio/teacher/start' do
    lesson = live_studio_lessons(:ready_lesson_for_false)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/live_start", {})
    assert_response :success
    assert data.length == 32
  end

  test 'GET /api/v1/live_studio/teacher/heartbeat' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/heartbeat", {})
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    token = data
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/heartbeat", {token: token})
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    assert data == token, '应该和之前的token一致'
  end

  test 'GET /api/v1/live_studio/teacher/close' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/live_end", {})
    assert_response :success
    assert data.length == 32, '没有正确返回'
  end
end
