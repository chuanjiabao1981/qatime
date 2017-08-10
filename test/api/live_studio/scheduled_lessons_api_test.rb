require 'test_helper'

class Qatime::ScheduledLessonsAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_with_order2)
    @student_remember_token = api_login(@student, :app)
  end

  test "student get replay" do
    lesson = live_studio_events(:replay_group1_scheduled_lesson1)
    get "/api/v1/live_studio/scheduled_lessons/#{lesson.id}/replay", {}, { 'Remember-Token' => @student_remember_token }
    assert_request_success?

    assert @res['data'].key?('replayable')
    assert @res['data'].key?('user_playable')
    assert @res['data'].key?('replay')
    assert @res['data']['replay'].key?('orig_url')
  end
end
