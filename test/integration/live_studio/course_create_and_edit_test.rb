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
      teacher = users(:teacher_one)
      workstation = @manager.workstations.sample

      assert_difference '@manager.live_studio_courses.count', 1 do
        visit live_studio.new_manager_course_path(@manager)
        fill_in :course_name, with: '测试英语辅导课程'
        fill_in :course_description, with: 'new course description'
        find('button[data-id="course_teacher_id"]').click
        find("ul.dropdown-menu.inner > li > a > span.text", text: teacher.name).click
        fill_in :course_price, with: 300.0
        fill_in :course_teacher_percentage, with: 10
        fill_in :course_preset_lesson_count, with: 15
        select workstation.name, from: 'course_workstation_id'
        select '语文', from: 'course_subject'
        select '六年级', from: 'course_grade'
        click_on '新增辅导班'
      end

      course = Course.last
      assert_equal(teacher.id, course.teacher_id, '辅导班老师指定错误')
      assert_equal(300, course.price.to_f, '定价出错')
      assert_equal(20, course.lesson_price.to_f, '单价计算错误')
    end

    test "manager create a course when price too lower" do
      teacher = users(:teacher_one)
      workstation = @manager.workstations.sample

      assert_difference '@manager.live_studio_courses.count', 0 do
        visit live_studio.new_manager_course_path(@manager)
        fill_in :course_name, with: '测试英语辅导课程'
        fill_in :course_description, with: 'new course description'
        find('button[data-id="course_teacher_id"]').click
        find("ul.dropdown-menu.inner > li > a > span.text", text: teacher.name).click
        fill_in :course_price, with: 2.0
        fill_in :course_teacher_percentage, with: 10
        fill_in :course_preset_lesson_count, with: 15
        select workstation.name, from: 'course_workstation_id'
        select '语文', from: 'course_subject'
        select '六年级', from: 'course_grade'
        click_on '新增辅导班'
      end

      page.has_content? "必须大于 75"
    end

    test "manager update a course" do
      course = Course.last
      teacher2 = users(:teacher_without_chat_account)

      visit live_studio.edit_manager_course_path(@manager, course)
      fill_in :course_name, with: '测试英语辅导课程更新'
      fill_in :course_description, with: 'edit course description'
      find('button[data-id="course_teacher_id"]').click
      find("ul.dropdown-menu.inner > li > a > span.text", text: teacher2.name).click
      fill_in :course_price, with: 80.0
      click_on '更新辅导班'
      course.reload
      assert_equal('测试英语辅导课程更新', course.name, '辅导班名称修改错误')
      assert_equal('edit course description', course.description, '辅导班描述修改错误')
      assert_equal(teacher2.id, course.teacher_id, '辅导班老师修改错误')
      assert_equal(80.0, course.price.to_f, '辅导班定价修改错误')
    end

    test 'manager select_btn search' do
      course = LiveStudio::Course.init.last
      teacher = users(:teacher_without_chat_account)
      visit live_studio.edit_manager_course_path(@manager, course)
      find('button[data-id="course_teacher_id"]').click
      assert_equal find("ul.dropdown-menu.inner").all('li').size,::Teacher.count+1, '没有正确加载select'
      find('div.bs-searchbox input').set("search_teacher")
      assert_equal find("ul.dropdown-menu.inner").all('li').size, 3, '数据匹配不正确'
      find('div.bs-searchbox input').set(teacher.name)
      assert_equal find("ul.dropdown-menu.inner").all('li').size,1,'没有匹配到数据'
    end
  end
end
