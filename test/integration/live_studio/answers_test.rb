require 'test_helper'

module LiveStudio
  # 回答测试
  class AnswersTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 老师添加回答
    test "teacher add a answer" do
      @question = live_studio_tasks(:question_one)
      visit live_studio.customized_group_path(@group)
      click_on '提问'
      click_on '地球为什么是圆的'
      click_on '添加回答'
      fill_in :answer_body, with: '地球不能是圆的吗？'
      click_on '取消'
      click_on '添加回答'
      fill_in :answer_body, with: '地球不能是圆的吗？'
      assert_difference "LiveStudio::Answer.count", 1, "答案创建失败" do
        click_on '新增回答'
        sleep(1)
      end
      assert_not_nil @question.reload.answer, "回答失败"
      assert @question.resolved?, "提问状态不正确"
      assert page.has_content?('地球不能是圆的吗？'), '新回答未显示'
    end

    # 老师添加回答
    test "teacher edit a answer" do
      @question = live_studio_tasks(:question_two)
      visit live_studio.customized_group_path(@group)
      click_on '提问'
      click_on '奶牛为什么能产牛奶'
      click_on '修改回答'
      fill_in :answer_body, with: '我把答案改了你还记得吗?'
      click_on '取消'
      click_on '修改回答'
      fill_in :answer_body, with: '我把答案改了你还记得吗?'
      assert_no_difference "LiveStudio::Answer.count", "答案重复创建" do
        click_on '更新回答'
        sleep(1)
      end
      assert_equal "我把答案改了你还记得吗?", @question.reload.answer.body, "回答修改失败"
      assert page.has_content?('我把答案改了你还记得吗?'), '修改回答未显示'
      assert @question.resolved?, "问题状态不正确"
    end
  end
end
