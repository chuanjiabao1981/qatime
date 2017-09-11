require 'test_helper'

module LiveStudio
  # 作业测试
  class HomewokrsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      @group = live_studio_groups(:published_group1)
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 老师查看我布置的作业
    test "teacher view homewokrs" do
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)
      click_on "我布置的作业"
      assert page.has_content?("第一个作业"), "作业显示不全"
      assert page.has_content?("第2个作业"), "作业显示不全"
      assert page.has_content?("第3个作业"), "作业显示不全"
    end

    # 老师添加新作业
    test "teacher add homewokrs" do
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)
      click_on "创建新作业"
      sleep(1)
      fill_in :homework_title, with: '布置新作业'
      fill_in :homework_task_items_attributes_0_body, with: '第1题会不会'
      click_on "添加下一题"
      fill_in :homework_task_items_attributes_1_body, with: '第2题会不会'
      click_on "添加下一题"
      fill_in :homework_task_items_attributes_2_body, with: '第3题会不会'
      assert_difference "@group.reload.homeworks.count", 1, "作业创建失败" do
        click_on "新增作业"
        sleep(1)
      end
      binding.pry
      click_on "我布置的作业"
      assert page.has_content?("布置新作业"), "新作业未显示"
    end

    # 老师查看其老师的专属课
    test "teacher view other's group" do
      @user = users(:teacher2)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on '作业'
      assert page.has_content?(""), "老师查看其他老师专属课作业显示不正确"
    end

    # 管理员查看作业列表
    test "admin view homeworks" do
    end
  end
end
