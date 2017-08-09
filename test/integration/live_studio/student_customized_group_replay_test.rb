require 'test_helper'

module LiveStudio
  # 一对一回放测试
  class StudentCustomizedGroupReplayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_with_order2)
      @course = live_studio_groups(:replay_group1)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test 'student visit replays' do
      visit live_studio.customized_group_path(@course)
      
      assert page.has_link?("观看回放"), "详情页课程没有回放链接"
      lesson = @course.scheduled_lessons.first
      visit live_studio.replay_scheduled_lesson_path(lesson)
      assert page.has_content? lesson.name
      assert page.has_content? '基本属性'
      assert page.has_content? '执教年龄'
      assert page.has_link?("观看回放"), "回放页课程没有回放链接"
    end
  end
end
