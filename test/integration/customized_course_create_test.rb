class CustomizedCourseCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager  = users(:manager)
  end

  def teardown
    #@headless.destroy

    visit get_home_url(@manager)
    click_on '退出'
    Capybara.use_default_driver
  end


  test "customized course create with teacher" do
    log_in_as(@manager)
    student1 = users(:student1)
    visit new_student_customized_course_path(student1)
    select '初中', from: :s_category
    select '高中', from: :s_category
    select '物理', from: :s_subject

    options = {from: 'customized-courses-teachers'}
    item_text = 'physics_teacher1'
    select_from_chosen(item_text,options)
    teacher = Teacher.find_by_name(item_text)
    assert_difference 'teacher.customized_courses.count',1 do
      page.has_content? "讲师: #{teacher.name}"
      click_on '新增专属课程'
    end
    # page.save_screenshot('screenshot.png')
  end

  test "customized course create without teacher" do
    log_in_as(@manager)
    student1 = users(:student1)
    visit new_student_customized_course_path(student1)
    assert_difference 'CustomizedCourse.count',1 do
      assert_difference 'CustomizedCourseAssignment.count',0 do
        click_on '新增专属课程'
        page.save_screenshot('screenshot.png')

      end
    end
    end
end