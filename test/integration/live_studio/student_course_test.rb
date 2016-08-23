require 'test_helper'

module LiveStudio
  class StudentCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = ::Student.find(users(:student_one_with_course).id)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student courses index view" do
      course = live_studio_courses(:course_preview)
      visit live_studio.student_courses_path(@student)
      page.has_content? course.name
    end

    test "student courses show view" do
      course = live_studio_courses(:course_preview)
      visit live_studio.student_course_path(@student,course)
      page.has_content? course.name
      page.has_content? course.teacher.name
      page.has_content? course.workstation.name
      page.has_content? course.description
      page.has_content? course.price
    end

    test 'student course filter' do
      click_on '辅导班'
      click_on '价格'
      page.find('.dropdown-submenu').hover
      fill_in :price_floor, with: '100'
      click_on '清除范围'
      assert_equal page.find("#price_floor", :visible => false).value, '', '没有清空范围'
    end
  end
end
