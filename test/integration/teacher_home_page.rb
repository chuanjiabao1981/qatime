require 'test_helper'

class TeacherHomePageTest < ActionDispatch::IntegrationTest

  def setup
    @teacher1         = Teacher.find(users(:teacher1).id)
    @teacher1_session = log_in2_as(@teacher1)
  end

  def teardown
    @teacher1           = nil
    log_out2(@teacher1_session)

    @teacher1_session   = nil
  end
  test "teacher lessons state" do

    @teacher1_session.get lessons_state_teacher_path(@teacher1)
    @teacher1_session.assert_template 'teachers/lessons_state'
    @teacher1_session.assert_response :success

  end

  test "teacher curriculums" do
    @teacher1_session.get curriculums_teacher_path(@teacher1)
    @teacher1_session.assert_template 'teachers/curriculums'
    @teacher1_session.assert_template layout: "layouts/teacher_home"

    @teacher1_session.assert_response :success

  end
end
