require 'test_helper'

class NotificationsTest < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    new_logout_as(@user)
    Capybara.use_default_driver
  end

  test "teacher view notification" do
    @user = users(:teacher1)
    @lesson = live_studio_lessons(:lesson_for_start_at_today1)
    log_in_as(@user)
    click_on "消息中心"
    assert_equal find(:css, '.news').text.to_i, @user.unread_notifications_count, '未读消息数目不对'
    if page.has_selector?('div.nav-right-user')
      find('.nav-right-user').hover
      assert_equal find(:css, '.nav-right-user .news').text.to_i, @user.unread_notifications_count, '未读消息数目不对'
    end
    assert_equal 13, page.find_all(".unread").count, "教师未读消息数量不正确"
    assert page.has_content?("新课程任务【今天开课辅导班】已接收，如对有疑问请联系您的工作站。"), "新的辅导班任务通知不正确"
    assert page.has_content?("新课程任务【测试一对一老师】已接收，如对有疑问请联系您的工作站。"), "新的一对一任务通知不正确"
    assert page.has_content?("【今天开课辅导班】将于今日(#{Date.today})开始上课。"), "教师辅导班开课通知显示不正确"
    assert page.has_content?("【测试一对一老师】已结束（原因：学生已退款），请联系您的工作站重新开设课程"), "学生退款通知显示不正确"
    assert page.has_content?("您的课程 \"今日开课辅导班-第一节课\" 将于#{@lesson.start_time}开始上课，请准时授课"), "教师上课提醒通知显示不正确"
    assert page.has_content?("【待发布视频课】审核被拒, 您可以重新编辑后再次提交审核"), "课程审核被拒通知"
    assert page.has_content?("【待发布视频课】审核通过, 请耐心等待工作站为您创建课程"), "课程审核通过通知"
    assert page.has_content?("【待发布视频课】发布成功, 您可以到个人中心进行查看和预览"), "课程发布通知"
  end

  test "student view notification" do
    @user = users(:student1)
    @lesson = live_studio_lessons(:lesson_for_start_at_today1)
    log_in_as(@user)
    click_on "消息中心"
    assert_equal find(:css, '.news').text.to_i, @user.unread_notifications_count, '未读消息数目不对'
    if page.has_selector?('div.nav-right-user')
      find('.nav-right-user').hover
      assert_equal find(:css, '.nav-right-user .news').text.to_i, @user.unread_notifications_count, '未读消息数目不对'
    end
    assert_equal 13, page.find_all(".unread").count, "学生未读消息数量不正确"
    assert page.has_content?("【今天开课辅导班】将于今日(#{Date.today})开始上课。"), "学生辅导班开课通知显示不正确"
    assert page.has_content?("您的课程 \"今日开课辅导班-第一节课\" 将于#{@lesson.start_time}开始上课，请准时参加学习"), "学生上课提醒通知显示不正确"
    assert page.has_content?("提现审核提醒"), "提现审核通知错误"
    assert page.has_content?("充值提醒"), "充值提醒通知错误"
  end

  test "others view notification" do
    @user = users(:teacher1)
    log_in_as(@user)
    click_on "消息中心"
    assert page.has_content?("您的课程 \"今日开课辅导班-第一节课\" 未能准时授课, 请尽快进行调课并补上, 以免影响您的教学安排"), "未上课通知不正确"
  end

  test "live studio course notification" do
    @user = users(:teacher1)
    log_in_as(@user)
  end
end
