class CustomizedCourseIntegrateTest < LoginTestBase

  def setup
    super
    @customized_course = customized_courses(:customized_course1)

  end

  test "course index" do
    index_page(@student_session,customized_courses_student_path(@student))
    index_page(@teacher_session,customized_courses_teacher_path(@teacher))
  end

  test "course show" do
    show_page(@student_session,customized_course_path(@customized_course))
    show_page(@teacher_session,customized_course_path(@customized_course))
  end

  test "action record" do
    action_record_page(@student_session,action_records_customized_course_path(@customized_course))
    action_record_page(@teacher_session,action_records_customized_course_path(@customized_course))
  end
  private
  def action_record_page(user_session,action_record_path)
    customized_course_action_record_for_tutorial_create                     = action_records(:customized_course_action_record_for_tutorial_create)
    customized_course_action_record_for_exercise_create                     = action_records(:customized_course_action_record_for_exercise_create)
    customized_course_action_record_for_tutorial_issue_create               = action_records(:customized_course_action_record_for_tutorial_issue_create)
    customized_course_action_record_for_tutorial_issue_reply_create         = action_records(:customized_course_action_record_for_tutorial_issue_reply_create)
    customized_course_action_record_for_homework_create                     = action_records(:customized_course_action_record_for_homework_create)
    customized_course_action_record_homework_solution_create                = action_records(:customized_course_action_record_homework_solution_create)
    customized_course_action_record_for_exercise_solution_create            = action_records(:customized_course_action_record_for_exercise_solution_create)
    customized_course_action_record_for_exercise_correction_create          = action_records(:customized_course_action_record_for_exercise_correction_create)
    customize_course_action_record_for_comment_homework_correction_create   = action_records(:customize_course_action_record_for_comment_homework_correction_create)
    customized_course_action_record_homework_correction_create              = action_records(:customized_course_action_record_homework_correction_create)
    customized_course_action_record_customized_course_message1_create       = action_records(:customized_course_action_record_customized_course_message1_create)
    assert customized_course_action_record_for_tutorial_create.valid?
    assert customized_course_action_record_for_exercise_create.valid?
    assert customized_course_action_record_for_tutorial_issue_create.valid?
    assert customized_course_action_record_for_tutorial_issue_reply_create.valid?
    assert customized_course_action_record_for_homework_create.valid?
    assert customized_course_action_record_homework_solution_create.valid?
    assert customized_course_action_record_for_exercise_solution_create.valid?
    assert customized_course_action_record_for_exercise_correction_create.valid?
    assert customize_course_action_record_for_comment_homework_correction_create.valid?
    assert customized_course_action_record_homework_correction_create.valid?
    assert customized_course_action_record_customized_course_message1_create.valid?
    user_session.get action_record_path
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]', customized_tutorial_path(customized_course_action_record_for_tutorial_create.actionable),1
    user_session.assert_select 'a[href=?]', exercise_path(customized_course_action_record_for_exercise_create.actionable),1
    user_session.assert_select 'a[href=?]', tutorial_issue_path(customized_course_action_record_for_tutorial_issue_create.actionable),1
    user_session.assert_select 'a[href=?]', tutorial_issue_reply_path(customized_course_action_record_for_tutorial_issue_reply_create.actionable),1
    user_session.assert_select 'a[href=?]', homework_path(customized_course_action_record_for_homework_create.actionable),1
    user_session.assert_select 'a[href=?]', homework_solution_path(customized_course_action_record_homework_solution_create.actionable),1
    user_session.assert_select 'a[href=?]', exercise_solution_path(customized_course_action_record_for_exercise_solution_create.actionable),1
    user_session.assert_select 'a[href=?]', exercise_correction_path(customized_course_action_record_for_exercise_correction_create.actionable),1
    user_session.assert_select 'a[href=?]', comment_path(customize_course_action_record_for_comment_homework_correction_create.actionable),1
    user_session.assert_select 'a[href=?]', homework_correction_path(customized_course_action_record_homework_correction_create.actionable),1
    user_session.assert_select 'a[href=?]', customized_course_message_path(customized_course_action_record_customized_course_message1_create.actionable),1
  end
  def index_page(user_session,indexpath)
    user_session.get indexpath
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]', customized_course_path(@customized_course),1
    user_session.assert_select 'a[href=?]', new_student_customized_course_path(@student),0
  end

  def show_page(user_session,showpath)
    user_session.get showpath
    user_session.assert_response :success

    #puts user_session.response.body
    if user_session.cookies["remember_user_type"] == "teacher"
      user_session.assert_select 'a[href=?]',new_customized_course_customized_tutorial_path(@customized_course),1
    else
      user_session.assert_select 'a[href=?]',new_customized_course_customized_tutorial_path(@customized_course),0
    end
    user_session.assert_template 'customized_courses/show'
    user_session.assert_select 'div'        , "课程: #{@customized_course.customized_tutorials_count}节"
    user_session.assert_select 'div'        , "学生: #{@customized_course.student.name}"
    user_session.assert_select 'a[href=?]'  , edit_student_customized_course_path(@student,@customized_course), 0
    user_session.assert_select 'a[href=?]'  , homeworks_customized_course_path(@customized_course),1
    user_session.assert_select 'a[href=?]'  , topics_customized_course_path(@customized_course),1
    @customized_course.customized_tutorials.each do |customized_tutorial|
      user_session.assert_select 'a[href=?]', customized_tutorial_path(customized_tutorial),1
      user_session.assert_select 'a', customized_tutorial.name
    end
  end
end