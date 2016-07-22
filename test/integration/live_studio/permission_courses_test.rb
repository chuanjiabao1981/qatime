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
      logout_as(@user)
      Capybara.use_default_driver
    end

    test 'manager course permission' do
      @user = users(:manager)
      log_in_as(@user)
      init_course = LiveStudio::Course.init.first
      cant_delete =  LiveStudio::Course.preview.first
      cant_edit = LiveStudio::Course.for_sell.last
      click_on '辅导班'
      # create course
      click_on '创建辅导班',match: :first
      click_on '新增辅导班',match: :first
      assert_match '请检查以下问题', page.text, '没有创建权限'
      click_on '辅导班'
      # edit init course
      click_on init_course.name
      page.go_back
      visit live_studio.edit_manager_course_path(@user,init_course)
      click_on '更新辅导班',match: :first
      assert_match '辅导班已更新',page.text, '初始化辅导班没有更新权限'
      # edit cant_edit
      visit live_studio.edit_manager_course_path(@user, cant_edit)
      assert_match '您没有权限进行这个操作', page.text, '无法编辑招生中的辅导班'
      # delete cant_edit
      cant_edit.tickets.destroy_all
      delete live_studio.manager_course_path(@user, cant_edit)
      assert_match '辅导班已删除', page.text, '无法删除辅导班'
      # delete cant_delete
      delete live_studio.manager_course_path(@user, cant_delete)
      assert_match '您没有权限进行这个操作', page.text, '删除了不能删除的辅导班'
    end

    # test 'seller course permission' do
    #   @user = users(:seller)
    #   log_in_as(@user)
    #   click_on '辅导班'
    #   # create course
    #   click_on '创建辅导班', match: :first
    #   click_on '新增辅导班', match: :first
    #   assert_match '请检查以下问题',page.text, '没有创建权限'
    #   # show course
    #   click_on '辅导班'
    #   init_course = @user.live_studio_courses.init.first
    #   click_on init_course.name, match: :first
    #   assert_match init_course.name, page.text, '没有正确访问辅导班详情'
    #   # edit init course
    #   visit live_studio.edit_seller_course_path(@user, init_course)
    #   click_on '更新辅导班', match: :first
    #   assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
    #   # edit not init course
    #   init_course.preview!
    #   visit live_studio.edit_seller_course_path(@user, init_course)
    #   assert_match '您没有权限进行这个操作',page.text, '不可以编辑招生中的辅导班'
    #   # cant delete
    #   delete live_studio.seller_course_path(@user, init_course)
    #   assert_match '您没有权限进行这个操作',page.text, '不可以删除辅导班'
    # end
    #
    # test 'waiter course permission' do
    #   @user = users(:waiter)
    #   log_in_as(@user)
    #   # show course
    #   click_on '辅导班'
    #   # cant create
    #   assert_no_match '创建辅导班', page.text, '不得出现创建辅导班链接'
    #   # cant edit
    #   assert_no_match '编辑', page.text, '不得出现编辑辅导班链接'
    #   # cant delete
    #   assert_no_match '删除', page.text, '不得出现删除辅导班链接'
    # end
    #
    # test 'teacher course permission' do
    #   @user = users(:teacher1)
    #   log_in_as(@user)
    #   init = @user.live_studio_courses.init.first
    #   # show course
    #   click_on '我的辅导班'
    #   click_on init.name, match: :first
    #   assert_match init.name, page.text, '没有正确访问show页面'
    #   # edit course
    #   click_on '编辑辅导班', match: :first
    #   click_on '更新辅导班', match: :first
    #   assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
    #   # create lesson
    #   click_on '创建课程',match: :first
    #   fill_in :lesson_name, with: 'test lesson'
    #   fill_in :lesson_description, with: 'test description'
    #   select '9:00', from: :lesson_start_time
    #   select '9:30', from: :lesson_end_time
    #   fill_in :lesson_class_date, with: Time.now.strftime('%Y/%m/%d')
    #   click_on '新增课程', match: :first
    #   assert_match '课程已创建', page.text, '没有创建课程'
    #   lesson = LiveStudio::Lesson.last
    #   # edit lesson
    #   visit live_studio.edit_teacher_lesson_path(@user, lesson, course_id: init.id)
    #   click_on '更新课程',match: :first
    #   # delete lesson
    #   delete live_studio.teacher_lesson_path(@user, lesson, course_id: init.id)
    #   assert_match '课程已删除', page.text, '没有删除课程'
    #   # cant edit lesson
    #   click_on '创建课程',match: :first
    #   fill_in :lesson_name, with: 'test lesson'
    #   fill_in :lesson_description, with: 'test description'
    #   select '9:00', from: :lesson_start_time
    #   select '9:30', from: :lesson_end_time
    #   fill_in :lesson_class_date, with: Time.now.strftime('%Y/%m/%d')
    #   click_on '新增课程', match: :first
    #   assert_match '课程已创建', page.text, '没有创建课程'
    #   lesson = LiveStudio::Lesson.last
    #   init.preview!
    #   visit live_studio.edit_teacher_lesson_path(@user, lesson, course_id: init.id)
    #   assert_match '您没有权限进行这个操作', page.text, '错误编辑已招生辅导班课程'
    #   # cant delete lesson
    #   delete live_studio.teacher_lesson_path(@user, lesson, course_id: init.id)
    #   assert_match '您没有权限进行这个操作', page.text, '错误删除已招生辅导班课程'
    # end
  end
end
