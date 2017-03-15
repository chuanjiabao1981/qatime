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
      new_log_in_as(@user)
      init_course = @user.live_studio_courses.init.first
      cant_edit = live_studio_courses(:course_for_edit)
      visit live_studio.manager_courses_path(@user)
      # create course
      click_on '开班邀请', match: :first
      click_on '创建新邀请', match: :first
      click_on '立即发送', match: :first
      assert_match '不能为空字符', page.text, '没有创建权限'
      visit live_studio.manager_courses_path(@user)
      # edit init course
      # click_on init_course.name
      # page.go_back
      # visit live_studio.edit_manager_course_path(@user,init_course)
      # find('button[data-id="course_teacher_id"]').click
      # find("ul.dropdown-menu.inner > li > a > span.text", text: 'teacher_one').click
      # click_on '更新辅导班',match: :first
      # assert_match '辅导班已更新',page.text, '初始化辅导班没有更新权限'
      # # edit cant_edit
      # visit live_studio.edit_manager_course_path(@user, cant_edit)
      # assert_match '您没有权限进行这个操作', page.text, '无法编辑招生中的辅导班'
      # # delete cant_edit
      # cant_edit.tickets.destroy_all
      # visit live_studio.manager_courses_path(@user)
      # click_link "delete_#{cant_edit.id}"
      # page.driver.browser.switch_to.alert.accept
      new_logout_as(@user)
    end

    test 'seller course permission' do
      # @user = users(:seller)
      # new_log_in_as(@user)
      # visit live_studio.seller_courses_path(@user)
      # # create course
      # click_on '创建辅导班', match: :first
      # click_on '新增辅导班', match: :first
      # assert_match '请检查以下问题',page.text, '没有创建权限'
      # # show course
      # visit live_studio.seller_courses_path(@user)
      # init_course = @user.live_studio_courses.init.first
      # click_on init_course.name, match: :first
      # assert_match init_course.name, page.text, '没有正确访问辅导班详情'
      # # edit init course
      # visit live_studio.edit_seller_course_path(@user, init_course)
      # click_on '更新辅导班', match: :first
      # assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
      # new_logout_as(@user)
    end

    test 'waiter course permission' do
      # @user = users(:waiter)
      # new_log_in_as(@user)
      # # show course
      # visit live_studio.waiter_courses_path(@user)
      # # cant create
      # assert_no_match '创建辅导班', page.text, '不得出现创建辅导班链接'
      # # cant edit
      # assert_no_match '编辑', page.text, '不得出现编辑辅导班链接'
      # # cant delete
      # assert_no_match '删除', page.text, '不得出现删除辅导班链接'
      # new_logout_as(@user)
    end

    test 'teacher course permission' do
      # @user = users(:teacher1)
      # new_log_in_as(@user)
      # init = @user.live_studio_courses.init.first
      # # 初始化辅导班
      # visit chat.finish_live_studio_course_teams_path(init)
      # visit chat.finish_live_studio_course_teams_path(init)
      # # show course
      # visit live_studio.teacher_courses_path(@user)
      # visit live_studio.teacher_course_path(@user,init)
      # assert_match init.name, page.text, '没有正确访问show页面'
      # # edit course
      # click_on '编辑辅导班', match: :first
      # click_on '保存', match: :first
      # assert_match '辅导班已更新', page.text, '没有更新初始化辅导班'
      # # create lesson
      # visit live_studio.edit_teacher_course_path(@user,init,index: 'list')
      # click_link '新增课程'
      # flag = init.lessons.count+1
      # fill_in "new_class_date_#{flag}", with: Time.now.strftime('%Y/%m/%d')
      # select '9:00', match: :first, from: "new_start_time_#{flag}"
      # select '9:30', match: :first, from: "new_end_time_#{flag}"
      # fill_in "new_name_#{flag}", with: 'test lesson'
      # click_on '保存'
      # assert_match '课程已更新', page.text, '没有创建课程'
    end
  end
end
