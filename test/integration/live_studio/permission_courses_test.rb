require 'test_helper'

module LiveStudio
  class PermissionCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'manager course permission' do
      @user = users(:manager)
      log_in_as(@user)
      init_course = @user.live_studio_courses.init.first
      cant_delete =  live_studio_courses(:course_for_tasting_for_delete)
      cant_edit = live_studio_courses(:course_for_edit)
      visit live_studio.manager_courses_path(@user)
      # create course
      click_on '创建辅导班',match: :first
      click_on '新增辅导班',match: :first
      assert_match '请检查以下问题', page.text, '没有创建权限'
      visit live_studio.manager_courses_path(@user)
      # edit init course
      click_on init_course.name
      page.go_back
      visit live_studio.edit_manager_course_path(@user,init_course)
      select 'teacher_one', from: :course_teacher_id
      click_on '更新辅导班',match: :first
      assert_match '辅导班已更新',page.text, '初始化辅导班没有更新权限'
      # edit cant_edit
      visit live_studio.edit_manager_course_path(@user, cant_edit)
      assert_match '您没有权限进行这个操作', page.text, '无法编辑招生中的辅导班'
      # delete cant_edit
      cant_edit.tickets.destroy_all
      visit live_studio.manager_courses_path(@user)
      click_link "delete_#{cant_edit.id}"
      page.driver.browser.switch_to.alert.accept
      assert_match '辅导班已删除', page.text, '无法删除辅导班'
      visit live_studio.manager_courses_path(@user)
      page.has_no_selector?("#delete_#{cant_delete.id}")
      logout_as(@user)
    end

    test 'seller course permission' do
      @user = users(:seller)
      log_in_as(@user)
      visit live_studio.seller_courses_path(@user)
      # create course
      click_on '创建辅导班', match: :first
      click_on '新增辅导班', match: :first
      assert_match '请检查以下问题',page.text, '没有创建权限'
      # show course
      visit live_studio.seller_courses_path(@user)
      init_course = @user.live_studio_courses.init.first
      click_on init_course.name, match: :first
      assert_match init_course.name, page.text, '没有正确访问辅导班详情'
      # edit init course
      visit live_studio.edit_seller_course_path(@user, init_course)
      click_on '更新辅导班', match: :first
      assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
      logout_as(@user)
    end

    test 'waiter course permission' do
      @user = users(:waiter)
      log_in_as(@user)
      # show course
      visit live_studio.waiter_courses_path(@user)
      # cant create
      assert_no_match '创建辅导班', page.text, '不得出现创建辅导班链接'
      # cant edit
      assert_no_match '编辑', page.text, '不得出现编辑辅导班链接'
      # cant delete
      assert_no_match '删除', page.text, '不得出现删除辅导班链接'
    end

    test 'teacher course permission' do
      @user = users(:teacher1)
      log_in_as(@user)
      init = @user.live_studio_courses.init.first
      prew = @user.live_studio_courses.preview.first
      # 初始化辅导班
      visit chat.finish_live_studio_course_teams_path(init)
      visit chat.finish_live_studio_course_teams_path(init)
      # show course
      visit live_studio.teacher_courses_path(@user)
      visit live_studio.teacher_course_path(@user,init)
      assert_match init.name, page.text, '没有正确访问show页面'
      # edit course
      click_on '编辑辅导班', match: :first
      click_on '保存', match: :first
      assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
      # create lesson
      click_on '编辑辅导班', match: :first
      visit live_studio.new_teacher_lesson_path(@user,course_id: init.id)
      fill_in :lesson_name, with: 'test lesson'
      fill_in :lesson_description, with: 'test description'
      select '9:00', from: :lesson_start_time
      select '9:30', from: :lesson_end_time
      fill_in :lesson_class_date, with: Time.now.strftime('%Y/%m/%d')
      click_on '新增课程', match: :smart
      assert_match '课程已创建', page.text, '没有创建课程'
      lesson = LiveStudio::Lesson.last
      # edit lesson
      visit live_studio.edit_teacher_lesson_path(@user, lesson, course_id: init.id)
      click_on '更新课程',match: :first
      # delete lesson
      page.has_content?('删除')
      # cant edit lesson
      click_on '我的辅导班'
      visit live_studio.teacher_course_path(@user,prew)
      assert !page.has_content?('编辑课程')
    end
  end
end
