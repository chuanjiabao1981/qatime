require 'test_helper'

module LiveStudio
  class ManagerVideoCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    # test "manager view video course my_publish" do
    #   click_on "视频课"
    #   click_on "发行/销售"
    #   assert page.has_link?('我的发行')
    #   assert page.has_link?('我的销售')
    #   assert page.has_content?('视频课名称')
    #   assert page.has_content?('老师分成')
    #   assert page.has_content?('发行分成')
    #   assert page.has_content?('购买人数')
    #   click_on '我的销售'
    #
    #   assert page.has_content?('销售分成')
    #   assert page.has_content?('平台分成')
    # end

    test "manager view video course audits" do
      click_on "课程管理"
      click_on '视频课'
      assert page.has_link?('视频审核')
      assert page.has_link?('创建发布')
      assert page.has_link?('已审核')
      assert page.has_link?('未审核')
      assert page.has_content?('课时数')
      assert page.has_content?('视频总长')
      assert page.has_content?('审核')
      assert_equal @manager.workstations.first.live_studio_video_courses.no_audit.count + 1, page.all('.sold-tab table tr').size
      assert page.has_link?('播放')
      assert page.has_link?('通过')
      assert page.has_link?('驳回')

      click_on '已审核'
      assert_equal @manager.workstations.first.live_studio_video_courses.audited.count + 1, page.all('.sold-tab table tr').size
      click_on '未审核'
      message = accept_prompt(with: '确定审核通过么?') do
        click_on '通过', match: :first
      end
      assert_equal 2, page.all('.sold-tab table tr').size

      message2 = accept_prompt(with: '确定驳回么?') do
        click_on '驳回', match: :first
      end
      assert_equal 1, page.all('.sold-tab table tr').size
      click_on '已审核'
      assert_equal 3, page.all('.sold-tab table tr').size
      assert page.has_content?('审核视频课1')
      assert page.has_content?('审核结果')
      assert page.has_content?('已通过')
      assert page.has_content?('已驳回')

      new_window = window_opened_by { click_on '播放', match: :first }
      within_window new_window do
        assert page.has_content? '课时安排'
        assert page.has_content? '教师资料'
      end
      new_window.close
    end

    test 'manager video course preview page' do
      course = live_studio_video_courses(:published_video_course1)
      visit live_studio.preview_video_course_path(course)

      assert page.has_content? '提示：此页面仅供查看和预览，不能进行操作哦！'
      assert page.has_content? course.name
      assert page.has_content? course.video_lessons.last.name
      assert page.has_content? '免费试听'
      assert page.has_content? '报名立减'
      assert page.has_content? '限时打折'
      assert page.has_content? '视频总长'
      assert page.has_link? '立即学习'
      assert page.has_link? '进入试听'
      assert page.has_link? '试听本课时'
      assert page.has_link? '观看本课时'
    end

  end
end
