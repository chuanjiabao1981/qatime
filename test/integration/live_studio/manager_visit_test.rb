require 'test_helper'

module LiveStudio
  class ManagerVisitTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
      @workstation = @manager.workstations.sample
      new_log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'visit teacher page' do
      @teacher = ::Teacher.first
      @course = @teacher.live_studio_courses.first
      click_on '教师'
      visit chat.finish_live_studio_course_teams_path(@course)
      visit teacher_path(@teacher)
      click_on '我的辅导'
      visit live_studio.teacher_course_path(@teacher, @course)
      assert_match @course.name, page.text, '没有正确跳转到辅导班详情页'
    end

    test 'visit student page' do
      @student = users(:student_one_with_course)
      @course = live_studio_courses(:course_preview)
      click_on '学生'
      visit student_path(@student)
      click_on '我的辅导'
      visit live_studio.student_course_path(@student, @course)
      assert_match @course.name, page.text, '--'
      page.go_back
      visit live_studio.courses_index_path
      sleep(20)
      assert_match(LiveStudio::Course.published.last.name, page.text, '没有正确跳转到辅导班搜索页')
    end

    test 'new & create seller' do
      click_on '销售'
      click_on '新增销售',match: :first
      fill_in :seller_name, with: 'seller'
      fill_in :seller_email, with: "#{('a'..'z').to_a.sample(5).join}@qatime.cn"
      fill_in :seller_login_mobile, with: "15911534521"
      fill_in :seller_password, with: 'password'
      fill_in :seller_password_confirmation, with: 'password'
      click_on '新增销售'
      assert_match('销售创建成功', page.text, '销售创建失败')
    end

    test 'edit & update seller' do
      @seller = users(:seller)
      click_on '销售'
      visit main_app.edit_station_workstation_seller_path(@seller.workstation, @seller)
      fill_in :seller_login_mobile, with: '13121246326'
      click_on '更新销售', match: :first
      assert_match('销售更新成功', page.text, '销售更新失败')
    end

    test 'new & create waiter' do
      click_on '客服'
      click_on '新增客服', match: :first
      fill_in :waiter_name, with: 'seller'
      fill_in :waiter_email, with: "#{('a'..'z').to_a.sample(5).join}@qatime.cn"
      fill_in :waiter_login_mobile, with: "15911534520"
      fill_in :waiter_password, with: 'password'
      fill_in :waiter_password_confirmation, with: 'password'
      click_on '新增客服'
      assert_match('客服创建成功', page.text, '客服创建失败')
    end

    test 'edit & update waiter' do
      @waiter = users(:waiter)
      click_on '客服'
      visit main_app.edit_station_workstation_waiter_path(@waiter.workstation, @waiter)
      fill_in :waiter_login_mobile, with: '13121246328'
      click_on '更新客服', match: :first
      assert_match('客服更新成功', page.text, '客服更新失败')
    end
  end
end
