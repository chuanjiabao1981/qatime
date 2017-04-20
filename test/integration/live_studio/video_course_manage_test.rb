require 'test_helper'

module LiveStudio
  class VideoCourseManageTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 创建视频课
    test 'complete and publish video course' do
      @user = users(:manager)
      @workstation = workstations(:workstation_one)
      @video_course = live_studio_video_courses(:confirmed_video_course)
      new_log_in_as(@user)
      visit main_app.station_workstation_path(@workstation)
      click_on '视频课'
      click_on '课程管理'
      find_link("创建", href: live_studio.edit_station_workstation_video_course_path(@workstation, @video_course)).click
      click_on '保存'
      assert page.has_content?('请输入课程目标'), "课程目标非空验证失效"
      assert page.has_content?('请输入适合人群'), "适合人群非空验证失效"
      assert page.has_content?('分成比例不正确'), "分成比例非空验证失效"
      fill_in 'video_course_objective', with: "课程目标"
      fill_in 'video_course_suit_crowd', with: "适合人群"
      fill_in 'video_course_price', with: "300"
      fill_in 'video_course_teacher_percentage', with: 100
      click_on '保存'
      assert page.has_content?('必须小于或等于 87'), "分成比例验证失效"
      fill_in 'video_course_teacher_percentage', with: 60

      assert_difference "@video_course.teacher.reload.notifications.count", 1, "老师没有收到发布通知" do
        click_on '保存并发布'
      end
      assert @video_course.reload.published?, "保存发布失败"
    end

    # 发布视频课
    test 'publish video course' do
      @user = users(:manager)
      @workstation = workstations(:workstation_one)
      @video_course = live_studio_video_courses(:completed_video_course)
      new_log_in_as(@user)
      visit main_app.station_workstation_path(@workstation)
      click_on '视频课'
      click_on '课程管理'
      click_on '已创建'
      assert_difference "@video_course.teacher.reload.notifications.count", 1, "老师没有收到发布通知" do
        find_link("发布", href: live_studio.publish_station_workstation_video_course_path(@workstation, @video_course)).click
      end
      assert @video_course.reload.published?, "发布失败"

      visit user_notifications_path(@video_course.teacher)
      binding.pry
      assert page.has_content?(""), "通知显示错误"
    end
  end
end
