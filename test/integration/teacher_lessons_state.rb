require 'test_helper'

class TeacherLessonsSateTest < ActionDispatch::IntegrationTest
  test "teacher lessons state" do
    teacher1          =  Teacher.find(users(:teacher1).id)
    teacher1_session = log_in2_as(teacher1)

    teacher1_session.get lessons_state_teacher_path(teacher1)
    teacher1_session.assert_template 'teachers/lessons_state'
    teacher1_session.assert_response :success

  end
end
