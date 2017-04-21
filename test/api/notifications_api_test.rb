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
    assert_includes contents, "【今天开课辅导班】将于今日(#{Date.today})开始上课。", "辅导班开课通知不正确"
    assert_includes contents, "您的课程 \"今日开课辅导班-第一节课\" 将于10:20开始上课，请准时参加学习", "课程上课提醒不正确"
  end

  # 通知设置接口测试 查询当前设置
  test "get current notification setting" do
    @student = users(:student1)
    @remember_token = api_login(@student, :app)
    get "/api/v1/users/#{@student.id}/notifications/settings", {}, 'Remember-Token' => @remember_token

    assert_response :success, "没有正确返回 #{JSON.parse(response.body)}"
    res = JSON.parse(response.body)
    assert_includes res['data'].keys, 'message', "设置信息不完整"
    assert_includes res['data'].keys, 'email', "设置信息不完整"
    assert_includes res['data'].keys, 'notice', "设置信息不完整"
    assert_includes res['data'].keys, 'before_hours', "设置信息不完整"
    assert_includes res['data'].keys, 'before_minutes', "设置信息不完整"
  end

  # 通知设置接口测试 更新设置
  test "update notification setting" do
    @student = users(:student1)
    @remember_token = api_login(@student, :app)
    put "/api/v1/users/#{@student.id}/notifications/settings",
        { message: 1, email: 0, notice: 0, before_hours: 2, before_minutes: 30 },
        'Remember-Token' => @remember_token

    assert_response :success, "没有正确返回 #{JSON.parse(response.body)}"
    res = JSON.parse(response.body)
    assert res['data']['message'], "短信通知设置错误"
    assert_not res['data']['email'], "邮件通知设置错误"
    assert_not res['data']['notice'], "系统通知设置错误"
    assert_equal 2, res['data']['before_hours'], "提前时间设置错误"
    assert_equal 30, res['data']['before_minutes'], "提前时间设置错误"
  end
end
