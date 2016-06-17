require 'test_helper'

module LiveStudio
  class StudentCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = ::Manager.find(users(:manager).id)
      @workstation = @manager.workstations.sample

      @teacher = ::Teacher.find(users(:teacher1).id)
      @student = ::Student.find(users(:student1).id)
      @course = Course.create(
                  name: "测试英语辅导课程",
                  description: 'new course description',
                  workstation_id: @workstation.id,
                  teacher_id: @teacher.id,
                  price: 100.0
                )
      CoursePurchaseRecord.create(
        student_id: @teacher,
        course_id: @student
      )

      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "teacher courses index view" do
      visit live_studio.student_courses_path
      page.has_content? @course.name
    end

    test "teacher courses show view" do
      visit live_studio.student_course_path(@course)
      page.has_content? @course.name
      page.has_content? @course.teacher.name
      page.has_content? @course.work_station.name
      page.has_content? @course.description
      page.has_content? @course.price
    end

  end
end
