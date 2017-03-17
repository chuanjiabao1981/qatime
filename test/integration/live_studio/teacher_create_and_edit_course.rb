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

    def upload_publicize
      click_on '点此更换图片'
      execute_script("$('#course_publicize').removeAttr('style');")
      attach_file("course_publicize","#{Rails.root}/test/integration/avatar.jpg")
      click_on '关闭'
    end

    test 'teacher create a course' do
      visit live_studio.new_course_path
      upload_publicize
      fill_in :course_name, with: 'test name'
      find('div[contenteditable]').set('test description')
      select '高一', from: 'course_grade'
      fill_in :course_price, with: '110'
      find('#course_tag_list').click
      click_on '小升初考试'
      click_on '周末课'
      click_on '确定'
      click_on '添加新课程'
      find('.class_date', match: :first).set(Time.now.tomorrow.to_s[0,10])
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('.duration', match: :first).find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('测试课程名称')
      click_on '保存'
      count = @teacher.live_studio_courses.count
      click_on '发布招生'
      assert_equal @teacher.live_studio_courses.last.tag_list, %w(小升初考试 周末课), '标签设置失败'
      assert_equal @teacher.live_studio_courses.count, count + 1, '辅导班创建失败'
    end

    test 'teacher edit a course' do
      visit live_studio.edit_course_path(@teacher.live_studio_courses.init.first)
      upload_publicize
      fill_in :course_name, with: 'test name'
      find('div[contenteditable]').set('test description')
      select '高一', from: 'course_grade'
      fill_in :course_price, with: '110'
      click_on '添加新课程'
      find('.class_date', match: :first).set(Time.now.tomorrow.to_s[0,10])
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('.duration', match: :first).find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('测试课程名称')
      click_on '保存'
      count = @teacher.live_studio_courses.count
      click_on '发布招生'
      assert_equal @teacher.live_studio_courses.count, count, '辅导班保存失败'
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
