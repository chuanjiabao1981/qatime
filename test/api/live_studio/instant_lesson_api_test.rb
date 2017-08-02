require 'test_helper'

class Qatime::InstantLessonAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @teacher_remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  test "teacher create instant lesson" do
    group = live_studio_groups(:published_group2)

    assert_difference "group.instant_lessons.count", 1, "答疑课创建失败" do
      post "/api/v1/live_studio/customized_groups/#{group.id}/instant_lessons", {}, 'Remember-Token' => @teacher_remember_token
      assert_response :success
      res = JSON.parse(response.body)
      assert res['data'].key?('id')
      assert res['data'].key?('status')
    end
  end
end
