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

  test "teacher fee info" do
    @physics_teacher1         = Teacher.find(users(:physics_teacher1).id)
    @physics_teacher1_session = log_in2_as(@physics_teacher1)
    @physics_teacher1_session.get info_teacher_path(@physics_teacher1,fee: :y)
    @customized_tutorial_teacher_earnings_1 = customized_tutorials(:customized_tutorial_teacher_earnings_1)
    @exercise_fee_solution_one              = solutions(:exercise_fee_solution_one)
    @reply_fee_tutorial_topic               = topics(:reply_fee_tutorial_topic)
    @solution_for_homework_correction_fee   = solutions(:solution_for_homework_correction_fee)
    assert @physics_teacher1.account.earning_records.length == 4
    # @physics_teacher1.account.earning_records.each do |e|
    #   puts e.fee.to_json
    # end
    @physics_teacher1_session.assert_response :success
    @physics_teacher1_session.assert_select "a[href=?]",customized_tutorial_path(@customized_tutorial_teacher_earnings_1)
    @physics_teacher1_session.assert_select "a[href=?]",solution_path(@exercise_fee_solution_one)
    @physics_teacher1_session.assert_select "a[href=?]",topic_path(@reply_fee_tutorial_topic)
    @physics_teacher1_session.assert_select "a[href=?]",solution_path(@solution_for_homework_correction_fee)

  end

  test "teacher topics" do
    topic1 = topics(:topic1)
    topic2 = topics(:teacher_topic1)
    @teacher1_session.get topics_teacher_path(@teacher1)
    @teacher1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    @teacher1_session.assert_select "a[href=?]", topic_path(topic2), count:1

  end


  test "customized tutorial topics" do
    topic1 = topics(:customized_tutorial_topic1)
    topic2 = topics(:customized_tutorial_topic2)
    @teacher1_session.get customized_tutorial_topics_teacher_path(@teacher1)

    @teacher1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    @teacher1_session.assert_select "a[href=?]", topic_path(topic2), count:1
    @teacher1_session.assert_response :success


  end

  test "teacher customized courses" do
    @teacher1_session.get customized_courses_teacher_path(@teacher1)
    @teacher1_session.assert_response :success

  end
end
