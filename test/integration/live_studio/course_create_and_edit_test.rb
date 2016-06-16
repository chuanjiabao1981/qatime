require 'test_helper'

module LiveStudio
  class CourseCreateAndEditTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @manager = ::Manager.find(users(:manager).id)
      log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager create a course" do
      teacher = Teacher.find(users(:teacher1).id)
      workstation = @manager.workstations.sample
      assert_difference '@manager.live_studio_courses.count', 1 do
        visit live_studio.new_manager_course_path(@directory)
        fill_in :course_name, with: '测试英语辅导课程'
        fill_in :course_description, with: 'new course description'
        fill_in :course_teacher_id, with: teacher.id
        fill_in :course_price, with: 100.0
        select workstation.name, from: 'course_workstation_id'
        click_on '新增Course'
      end
      course = Course.last
      assert_equal(teacher.id, course.teacher_id, '辅导班老师指定错误')
      assert_equal(100.0, course.price.to_f, '定价出错')
    end
  end
end
