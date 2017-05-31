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
      click_on '课程管理'
      click_on '视频课'
      click_on '创建发布'
      find_link("创建", href: live_studio.edit_station_workstation_video_course_path(@workstation, @video_course)).click
      find('#video_course_sell_type_charge').click
      click_on '保存'
      # assert page.has_content?('请输入课程目标'), "课程目标非空验证失效"
      # assert page.has_content?('请输入适合人群'), "适合人群非空验证失效"
      assert page.has_content?('分成比例不正确'), "分成比例非空验证失效"
      fill_in 'video_course_objective', with: "课程目标"
      fill_in 'video_course_suit_crowd', with: "适合人群"
      fill_in 'video_course_price', with: "300"
      fill_in 'video_course_teacher_percentage', with: 100
      click_on '保存'
      assert page.has_content?('必须小于或等于 87'), "分成比例验证失效"
      fill_in 'video_course_teacher_percentage', with: 60

      new_window = window_opened_by { click_on '预览' }
      within_window new_window do
        assert page.has_content? '提示：此页面仅供查看和预览，不能进行操作哦！'
        assert page.has_content? @video_course.name
        assert page.has_link? '立即学习'
      end
      new_window.close

      click_on '保存并发布'
      assert @video_course.reload.published?, "保存发布失败"
    end

    # 发布视频课
    test 'publish video course' do
      @user = users(:manager)
      @workstation = workstations(:workstation_one)
      @video_course = live_studio_video_courses(:completed_video_course)
      new_log_in_as(@user)
      visit main_app.station_workstation_path(@workstation)
      click_on '课程管理'
      click_on '视频课'
      click_on '创建发布'
      click_on '已创建'
      find_link("发布", href: live_studio.publish_station_workstation_video_course_path(@workstation, @video_course)).click
      assert @video_course.reload.published?, "发布失败"
    end
  end
end
