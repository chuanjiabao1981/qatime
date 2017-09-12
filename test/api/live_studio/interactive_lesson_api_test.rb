require 'test_helper'
class Qatime::InteractiveLessonAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_with_order2)
    @student_remember_token = api_login(@student, :app)
  end

  test 'student get replay' do
    @lesson = live_studio_interactive_lessons(:interactive_lesson_replay1)
    get "/api/v1/live_studio/interactive_lessons/#{@lesson.id}/replay", {}, 'Remember-Token' => @student_remember_token
    assert_response :success
    res = JSON.parse(response.body)


    assert_equal 1, res['status']
    assert res['data'].key?('replayable')
    assert res['data'].key?('user_playable')
    assert res['data'].key?('replay')
    assert_equal @lesson.replays.board.merged.count, res['data']['replay'].count, '一对一回放数量不正确'
  end
end
