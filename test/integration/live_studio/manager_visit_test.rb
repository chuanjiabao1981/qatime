require 'test_helper'

module LiveStudio
  class ManagerVisitTest < ActionDispatch::IntegrationTest
    def setup
      @manager = users(:manager)
      @workstation = @manager.workstations.sample
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'visit teacher page' do
      @teacher = Teacher.first
      @course = @teacher.live_studio_courses.first
      click_on '教师'
      visit teacher_path(@teacher)
      click_on '我的辅导班'
      click_on @course.name,match: :first
      assert_match @course.name, page.text, '没有正确跳转到辅导班详情页'
    end

    test 'visit student page' do
      @student = users(:student_one_with_course)
      @course = live_studio_courses(:course_preview)
      click_on '学生'
      visit student_path(@student)
      click_on '我的辅导班'
      click_on @course.name,match: :first
      assert_match @course.name, page.text, '--'
      page.go_back
      click_on '搜索辅导班', match: :first
      assert_match(LiveStudio::Course.preview.last.name, page.text, '没有正确跳转到辅导班搜索页')
    end

    test 'new & create seller' do
      click_on '销售'
      click_on '增加销售',match: :first
      fill_in :seller_name, with: 'seller'
      fill_in :seller_email, with: "#{('a'..'z').to_a.sample(5).join}@qatime.cn"
      fill_in :seller_password, with: 'password'
      fill_in :seller_password_confirmation, with: 'password'
      select @workstation.name, from: :seller_workstation_id
      click_on '新增销售'
      assert_match('销售已创建', page.text, '销售创建失败')
    end

    test 'edit & update seller' do
      @seller = users(:seller)
      click_on '销售'
      visit edit_managers_seller_path(@seller)
      fill_in :seller_mobile, with: '13121249326'
      click_on '更新销售', match: :first
      assert_match('销售已更新', page.text, '销售更新失败')
    end

    test 'new & create waiter' do
      click_on '客服'
      click_on '增加客服',match: :first
      fill_in :waiter_name, with: 'seller'
      fill_in :waiter_email, with: "#{('a'..'z').to_a.sample(5).join}@qatime.cn"
      fill_in :waiter_password, with: 'password'
      fill_in :waiter_password_confirmation, with: 'password'
      select @workstation.name, from: :waiter_workstation_id
      click_on '新增客服'
      assert_match('客服已创建', page.text, '客服创建失败')
    end

    test 'edit & update waiter' do
      @waiter = users(:waiter)
      click_on '客服'
      visit edit_managers_waiter_path(@waiter)
      fill_in :waiter_mobile, with: '13121249326'
      click_on '更新客服', match: :first
      assert_match('客服已更新', page.text, '客服更新失败')
    end
  end
end
