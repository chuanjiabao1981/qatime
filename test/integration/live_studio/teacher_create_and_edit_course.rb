require 'test_helper'

module LiveStudio
  class CourseCreateAndEditTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher1)
      log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test 'teacher create a course' do
      visit live_studio.new_course_path
      click_on '点此更换图片'
      execute_script("$('#course_publicize').removeAttr('style');")
      attach_file("course_publicize","#{Rails.root}/test/integration/avatar.jpg")
      click_on '关闭'
      fill_in :course_name, with: 'test name'
      fill_in :course_description, with: 'test description'
      select '高一', from: 'course_grade'
      fill_in :course_price, with: '110'
      click_on '添加新课程'
      click_on '取消'
      click_on '发布招生'
      assert_equal page.has_content?('请添加至少一节课程'), true
      assert_equal page.has_content?('工作站'),true
    end

    # test "teacher create a course" do
    #   visit live_studio.teacher_courses_path(@teacher)
    #   city = @teacher.city
    #   @workstation = city.workstations.first
    #   click_link "创建辅导班"
    #   assert_difference "@teacher.live_studio_courses.count", 1, "辅导班创建失败" do
    #     assert_difference "@workstation.live_studio_courses.count", 1, "根据地区选择工作站失败" do
    #       fill_in :course_name, with: '测试英语辅导课程'
    #       fill_in :course_description, with: 'new course description'
    #       fill_in :course_price, with: 100
    #       fill_in :course_preset_lesson_count, with: 15
    #       fill_in :course_taste_count, with: 2
    #       select '语文', from: 'course_subject'
    #       select '六年级', from: 'course_grade'
    #       click_on '新增辅导班'
    #     end
    #   end
    # end
    #
    # test "teacher create a course with taste" do
    #   visit live_studio.teacher_courses_path(@teacher)
    #   city = @teacher.city
    #   @workstation = city.workstations.first
    #   click_link "创建辅导班"
    #   fill_in :course_name, with: '测试英语辅导课程'
    #   fill_in :course_description, with: 'new course description'
    #   fill_in :course_price, with: 100
    #   fill_in :course_preset_lesson_count, with: 2
    #   fill_in :course_taste_count, with: 3
    #   select '语文', from: 'course_subject'
    #   select '六年级', from: 'course_grade'
    #   click_on '新增辅导班'
    #   assert page.has_content?('必须小于或等于 2')
    # end
  end
end
