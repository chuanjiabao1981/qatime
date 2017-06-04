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

      @teacher = users(:teacher_for_billing)
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "teacher update a courses" do
      course = live_studio_courses(:course_one_of_teacher_one)
      visit chat.finish_live_studio_course_teams_path(course)

      visit live_studio.edit_course_path(course)
      fill_in :course_name, with: '测试英语辅导课程更新'
      fill_in :course_objective, with: '这是课程目标'
      fill_in :course_suit_crowd, with: '这是适合人群'
      find('div.note-editable').set('edit course description')
      click_on '发布招生'
      course.reload
      assert_equal('测试英语辅导课程更新', course.name, '辅导班名称修改错误')
      assert_equal('<p>edit course description</p>', course.description, '辅导班描述修改错误')
    end

    test 'teacher visit other teacher course' do
      other_teacher = users(:english_teacher)
      visit live_studio.teacher_courses_path(other_teacher)
      assert_match('您没有权限进行这个操作', page.text, '错误: 教师访问其他老师的辅导班')
    end
  end
end
