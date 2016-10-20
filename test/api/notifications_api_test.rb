require 'test_helper'
class Qatime::NotificationsAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "GET /api/v1/users/:user_id/notifications get student notifications list" do
    @student = users(:student1)
    @remember_token = api_login(@student, :app)
    get "/api/v1/users/#{@student.id}/notifications", {}, 'Remember-Token' => @remember_token

    assert_response :success, "没有正确返回 #{JSON.parse(response.body)}"
    res = JSON.parse(response.body)
    data = res['data']
    assert_equal 10, data.count, "通知数量不正确"
    contents = data.map {|d| d["notice_content"]}
    assert_includes contents, "t老师,上传了专属课程", "上传专属课程通知不正确"
    assert_includes contents, "t老师,布置了随堂练习", "布置了随堂练习通知不正确"
    assert_includes contents, "t老师,批改了随堂作业", "批改了随堂作业通知不正确"
    assert_includes contents, "t老师,解答了随堂问题", "解答了随堂问题通知不正确"
    assert_includes contents, "t老师,布置了家庭作业", "布置了家庭作业通知不正确"
    assert_includes contents, "t老师留言", "老师留言通知不正确"
    assert_includes contents, "您的辅导班【今天开课辅导班】已于今日(#{Date.today})开课", "辅导班开课通知不正确"
    assert_includes contents, "您的课程 \"今日开课辅导班-第一节课\" 将于10:20开始上课，请准时参加学习", "课程上课提醒不正确"
  end
end
