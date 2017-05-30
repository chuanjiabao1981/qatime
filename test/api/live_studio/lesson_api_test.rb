require 'test_helper'
class Qatime::LessonAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  def app
    Rails.application
  end

  def data
    JSON.parse(response.body)['data']['live_token']
  end

  def get_url(url, params)
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
    post url, params: params, headers: { 'Remember-Token' => @remember_token }
  end

  test 'GET /api/v1/live_studio/teacher/start' do
    lesson = live_studio_lessons(:ready_lesson_for_false)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/live_start", board: 1, camera: 0)
    assert_response :success
    assert data.length == 32
  end

  test 'GET /api/v1/live_studio/teacher/start return error by student' do
    lesson = live_studio_lessons(:ready_lesson_for_false)

    post "/api/v1/live_studio/lessons/#{lesson.id}/live_start", params: { board: 1, camera: 0 }, headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'GET /api/v1/live_studio/teacher/heartbeat' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/heart_beat", beat_step: 60, timestamp: Time.now.to_i)
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    token = data
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/heart_beat", token: token, beat_step: 60, timestamp: Time.now.to_i)
    assert_response :success
    assert data.length == 32, '没有正确返回token'
    assert data == token, '应该和之前的token一致'
  end

  test 'GET /api/v1/live_studio/lessons/live_end' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    get_url("/api/v1/live_studio/lessons/#{lesson.id}/live_end", {})
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data['status'] == 'closed', '没有正确返回'
  end

  test 'post /api/v1/live_studio/teacher/close return error by student' do
    lesson = live_studio_lessons(:english_lesson_onlive)
    post "/api/v1/live_studio/lessons/#{lesson.id}/live_end", params: {}, headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'student get replay' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)
    @lesson = live_studio_lessons(:lesson_for_taste_zero)
    get "/api/v1/live_studio/lessons/#{@lesson.id}/replay", params: {}, headers: { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 8, res['data'].size
  end
end
