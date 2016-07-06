require 'test_helper'

module LiveStudio
  class TeacherCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = ::Manager.find(users(:manager).id)
      @workstation = @manager.workstations.sample

      @teacher = ::Teacher.find(users(:teacher_one).id)

      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "teacher update a courses" do
      course = live_studio_courses(:course_one_of_teacher_one)
      visit live_studio.edit_teacher_course_path(@teacher,course)
      fill_in :course_name, with: '测试英语辅导课程更新'
      fill_in :course_description, with: 'edit course description'
      click_on '更新辅导班'
      course.reload
      assert_equal('测试英语辅导课程更新', course.name, '辅导班名称修改错误')
      assert_equal('edit course description', course.description, '辅导班描述修改错误')
    end
  end
end
