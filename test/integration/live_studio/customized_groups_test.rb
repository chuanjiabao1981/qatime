require 'test_helper'

module LiveStudio
  # 专属课测试
  class CustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test "customized group show page" do
      customized_group = live_studio_groups(:published_group1)
      visit live_studio.customized_group_path(customized_group)
      assert page.has_content?(customized_group.name)
      assert page.has_content? '随时可退'
      assert page.has_content? '报名立减'
      assert page.has_content? '限时打折'

      assert page.has_link? '立即报名'
      assert page.has_no_link? '发布公告'
      assert page.has_link? customized_group.teacher_name
      click_on '上课安排'
      assert page.has_content? '上课地点：教学大厦1层403'
    end

    test "teacher visit customized group show page" do
      customized_group = live_studio_groups(:published_group1)
      teacher1 = users(:teacher1)
      log_in_as(teacher1)
      visit live_studio.customized_group_path(customized_group)
      assert page.has_link? '发布公告'
      message = accept_prompt(with: '请使用学生帐号操作') do
        click_on '立即报名', match: :first
      end
      click_on '发布公告', match: :first
      sleep(1)
      fill_in :announcement_content, with: '测试公告啊测试公告啊测试公告啊'
      assert_difference "LiveStudio::Announcement.count", 1, "发布公告失败" do
        click_on "发布"
      end
      new_logout_as(teacher1)
    end

    test "teacher visit completed customized group show page" do
      customized_group = live_studio_groups(:completed_group1)
      teacher1 = users(:teacher1)
      log_in_as(teacher1)
      visit live_studio.customized_group_path(customized_group)
      assert page.has_link? '已结束'
      new_logout_as(teacher1)

      teacher2 = users(:teacher2)
      log_in_as(teacher2)
      visit live_studio.customized_group_path(customized_group)
      assert page.has_link? '已下架'
      assert page.has_no_link? '发布公告'
      new_logout_as(teacher2)
    end

    test "customized group index page" do
      visit live_studio.customized_groups_path
      assert find('.select-tab').has_link?('专属课')
      find('.nav-all').hover
      click_on '近2个月'
      assert page.has_content?('近2个月')

      click_on '高一'
      click_on '语文'
      assert page.has_content?('高一语文')
      assert page.has_no_content?('高二英语')

      click_on '招生中'
      assert page.has_link?('发布的专属课1')

      click_on '收费课程'
      assert page.has_link?('发布的专属课1')
      fill_in :q_start_at_gteq, with: Date.today.to_s
      fill_in :q_start_at_lt, with: 3.days.since.to_date.to_s
      execute_script("$('#search-form').submit();")
    end
  end
end
