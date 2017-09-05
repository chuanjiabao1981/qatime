require 'test_helper'

class Qatime::TeacherInteractiveLessonsAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 我的一对一
  test 'teacher live lesson' do
    interactive_lesson = live_studio_interactive_lessons(:interactive_course_three_2_lesson_2)
    # 开始上课
    post "/api/v1/live_studio/interactive_lessons/#{interactive_lesson.id}/live_start", { room_id: Time.now.to_i.to_s, channel_id: '123456' }, 'Remember-Token' => @remember_token
    assert_request_success?
    assert interactive_lesson.reload.teaching?, "开始上课失败"
    live_token = @res['data']['live_token']
    step = @res['data']['beat_step']
    # 多次心跳
    10.times do
      post "/api/v1/live_studio/interactive_lessons/#{interactive_lesson.id}/heart_beat",
           { live_token: live_token, beat_step: step },
           'Remember-Token' => @remember_token
      sleep 1
    end
    assert_equal 1, interactive_lesson.live_sessions.count, "上课心跳记录错误"
    post "/api/v1/live_studio/interactive_lessons/#{interactive_lesson.id}/heart_beat",
         { beat_step: step },
         'Remember-Token' => @remember_token
    # 结束上课
    post "/api/v1/live_studio/interactive_lessons/#{interactive_lesson.id}/live_end", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert interactive_lesson.reload.closed?, "上课结束失败"
    assert_equal 22, interactive_lesson.live_sessions.sum(:duration), "上课时长结算错误"
    assert_equal 2, interactive_lesson.live_sessions.count, "上课心跳记录错误"
  end
end
