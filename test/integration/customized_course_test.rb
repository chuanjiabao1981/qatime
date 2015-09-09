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
  private
  def index_page(user_session,indexpath)
    user_session.get indexpath
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]', customized_course_path(@customized_course),1
    user_session.assert_select 'a[href=?]', new_student_customized_course_path(@student),0
    user_session.assert_select 'div'      , @customized_course.category
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
      if user_session.cookies["remember_user_type"] == "teacher"
        user_session.assert_select 'a[href=?]',edit_customized_tutorial_path(customized_tutorial),1
      else
        user_session.assert_select 'a[href=?]',edit_customized_tutorial_path(customized_tutorial),0
      end
    end

  end
end