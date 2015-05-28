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

  test "teacher info" do
    @teacher1_session.get info_teacher_path(@teacher1)
    @teacher1_session.assert_select "a[href=?]", edit_teacher_path(@teacher1), count: 1
  end

  test "teacher topics" do
    topic1 = topics(:topic1)
    topic2 = topics(:teacher_topic1)
    @teacher1_session.get topics_teacher_path(@teacher1)
    @teacher1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    @teacher1_session.assert_select "a[href=?]", topic_path(topic2), count:1

  end

end
