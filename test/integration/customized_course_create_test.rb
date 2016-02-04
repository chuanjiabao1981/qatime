class CustomizedCourseCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager  = users(:manager)
  end

  def teardown
    #@headless.destroy
    logout_as(@manager)
    # visit get_home_url(@manager)
    # click_on '退出'
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

  test "customize course edit" do
    log_in_as(@manager)
    customized_course1 = customized_courses(:customized_course1)
    visit edit_student_customized_course_path(customized_course1.student,customized_course1)
    old_teacher1       = customized_course1.teachers[0]
    old_teacher2       = customized_course1.teachers[1]
    options = {from: 'customized-courses-teachers'}
    item_text = 'physics_teacher1'
    teacher = Teacher.find_by_name(item_text)

    select '高中', from: :s_category
    select '物理', from: :s_subject
    # page.save_screenshot('screenshot11.png')

    select_from_chosen(item_text,options)
    # page.save_screenshot('screenshot22.png')

    assert_difference 'teacher.customized_courses.count',1 do
      assert_difference 'old_teacher1.customized_courses.count',-1 do
        assert_difference 'old_teacher2.customized_courses.count',-1 do
          assert_difference 'CustomizedCourse.count',0 do
            assert_difference 'CustomizedCourseAssignment.count',-1 do
              click_on '更新专属课程'
            end
          end
        end
      end
    end
    page.has_content? "讲师: #{teacher.name}"
  end

  test "customized course edit price changed" do
    log_in_as(@manager)
    student1 = users(:student1)

    customized_course1 = customized_courses(:customized_course1)

    teacher_price = customized_course1.teacher_price
    visit edit_student_customized_course_path(customized_course1.student,customized_course1)

    select '冲刺班', from: :s_customized_course_type
    click_on '更新专属课程'
    customized_course1.reload
    assert_not_equal customized_course1.teacher_price, teacher_price
  end

  test "customize course create link" do
    log_in_as(@manager)
    student1 = users(:student1)
    visit customized_courses_student_path(student1)
    page.has_link? new_student_customized_course_path(student1)
  end
end
