require 'test_helper'

module LiveStudio
  # 提问测试
  class QuestionsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @group = live_studio_groups(:schedule_published_group1)
      @group_other = live_studio_groups(:published_group1)
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 老师查看我布置的作业
    test "teacher view questions" do
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on '提问'
      click_on '奶牛为什么能产牛奶'
      assert page.has_content?('我回复的答案'), '老师回答不显示'
      assert page.has_content?('修改回答'), '修改回答未显示'
      click_on '地球为什么是圆的'
      assert page.has_content?('添加回答'), '添加回答未显示'
    end

    # 老师查看其老师的专属课
    test "teacher view other group question" do
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group_other)
      click_on '提问'
      assert page.has_content?('报名后才能查看'), '权限控制失效'
    end

    # 学生查看提问列表
    test "student view questions" do
      @user = users(:student_one_with_course)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on '提问'
      sleep(1)
      click_on '奶牛为什么能产牛奶'
      assert page.has_content?('老师回复的答案'), '老师回答不显示'
      assert page.has_content?('我也不知道'), '老师回答显示不正确'
      assert page.has_no_content?('修改回答'), "修改回答按钮错误显示"
      click_on '地球为什么是圆的'
      assert page.has_no_content?('添加回答'), "添加回答按钮错误显示"
      assert page.has_no_content?('老师回复的答案'), "老师回答错误显示"
      click_on '我的提问'
      assert page.has_no_content?('怎么观看直播'), '其他人提问错误显示'
      click_on '全部提问'
      assert page.has_content?('怎么观看直播'), '没显示有其他人提问'
    end

    # 学生提问
    test "student add a question" do
      @user = users(:student_one_with_course)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on '提问'
      sleep(1)
      find("#ask").click_on('提问')
      fill_in :question_title, with: '明天会下雨吗'
      fill_in :question_body, with: '谁知道明天会不会下雨，大雨还是小雨'
      click_on '取消'
      find("#ask").click_on('提问')
      fill_in :question_title, with: '明天会下雨吗'
      fill_in :question_body, with: '谁知道明天会不会下雨，大雨还是小雨'
      assert_difference "@group.reload.questions.count", 1, "提问创建失败" do
        click_on '新增提问'
        sleep(1)
      end
      question = @group.questions.last
      assert_equal @group.teacher, question.teacher, '提问老师错误'
      assert question.pending?, "提问状态不正确"
      click_on '我的提问'
      assert page.has_content?('明天会下雨吗'), '新提问未显示'
      click_on '全部提问'
      assert page.has_content?('明天会下雨吗'), '新提问未显示'
    end

    # 学生未购买查看问题
    test "student view other group question" do
      @user = users(:student_one_with_course)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group_other)
      click_on '提问'
      assert page.has_content?('报名后才能查看'), '权限控制失效'
    end
  end
end
