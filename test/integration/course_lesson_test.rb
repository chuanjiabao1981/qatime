require 'test_helper'

class CourseLessonTest < ActionDispatch::IntegrationTest
  def setup
    @teacher          = Teacher.find(users(:teacher1).id)
    @teacher_session  = log_in2_as(@teacher)
    @student          = Student.find(users(:student1).id)
    @student_session  = log_in2_as(@student)
    @lesson           = lessons(:teacher1_lesson)
    @course           = @lesson.course
  end


  def teardown
    @teacher           = nil
    @student           = nil
    log_out2(@teacher_session)
    log_out2(@student_session)
    @teacher_session   = nil
    @student_session   = nil
  end

  test "teacher show" do
    course_show_page(@teacher_session)
    lesson_show_page(@teacher_session)
  end

  test "student show" do
    course_show_page(@student_session)
    lesson_show_page(@student_session)
  end

  private
  def course_show_page(user_session)
    user_session.get course_path(@course)
    user_session.assert_template 'lessons/show'
    user_session.assert_response :success
  end
  def lesson_show_page(user_session)
    user_session.get lesson_path(@lesson)
    user_session.assert_template 'lessons/show'
    user_session.assert_response :success
  end
end