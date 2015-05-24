require 'test_helper'

class CourseTest < ActionDispatch::IntegrationTest
  def setup
    @teacher         = Teacher.find(users(:teacher1).id)
    @teacher_session = log_in2_as(@teacher)
    @lesson          = lessons(:teacher1_lesson)
    @course          = @lesson.course
    puts @course.curriculum
    puts "-========"
    puts @course.curriculum.teaching_program
    puts "======="
  end


  def teardown
    @teacher           = nil
    log_out2(@teacher_session)

    @teacher_session   = nil
  end

  test "course show" do
    common_page(@teacher_session)
  end

  private
  def common_page(user_session)
    user_session.get course_path(@course)
    user_session.assert_template 'courses/show'
    user_session.assert_response :success
  end
end