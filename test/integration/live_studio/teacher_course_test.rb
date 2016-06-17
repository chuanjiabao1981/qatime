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

      @teacher = ::Teacher.find(users(:teacher1).id)

      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "teacher update a courses" do
      course = Course.create(
                  name: "测试英语辅导课程",
                  description: 'new course description',
                  workstation_id: @workstation.id,
                  teacher_id: @teacher.id,
                  price: 100.0
                )

      visit live_studio.edit_teacher_course_path(course)
      fill_in :course_name, with: '测试英语辅导课程更新'
      fill_in :course_description, with: 'edit course description'
      fill_in :course_teacher_id, with: 2
      fill_in :course_price, with: 80.0
      click_on '更新Course'

      assert_equal(course.name, '测试英语辅导课程更新', '辅导班名称修改错误')
      assert_equal(course.description, 'edit course description', '辅导班描述修改错误')
      assert_equal(course.teacher_id, 2, '辅导班老师修改错误')
      assert_equal(course.price.to_f, 80.0, '辅导班定价修改错误')
    end

  end
end
