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

  test "teacher fee info" do
    @physics_teacher1                       = Teacher.find(users(:physics_teacher1).id)
    @physics_teacher1_session               = log_in2_as(@physics_teacher1)

    @physics_teacher1_session.get info_teacher_path(@physics_teacher1,fee: :y)





    @physics_teacher1_session.assert_response :success

    @customized_tutorial_teacher_earnings_1 = customized_tutorials(:customized_tutorial_teacher_earnings_1)
    @course_issue_reply_for_fee_view        = replies(:course_issue_reply_for_fee_view)
    @tutorial_issue_reply_for_fee_view      = replies(:tutorial_issue_reply_for_fee_view)
    @exercise_correction_for_fee_view       = corrections(:exercise_correction_for_fee_view)
    @homework_correction_for_fee_view       = corrections(:homework_correction_for_fee_view)

    # @physics_teacher1.account.earning_records.each do |x|
    #   puts x.fee.to_json
    # end
    @physics_teacher1_session.assert_select "a[href=?]", customized_tutorial_path(@customized_tutorial_teacher_earnings_1)
    @physics_teacher1_session.assert_select "td",CustomizedTutorial.model_name.human
    @physics_teacher1_session.assert_select "td",@customized_tutorial_teacher_earnings_1.fee.value.to_s
    @physics_teacher1_session.assert_select "a[href=?]", course_issue_reply_path(@course_issue_reply_for_fee_view.id)#,page:1,reply_aminate:@course_issue_reply_for_fee_view.id,anchor:"reply_#{@course_issue_reply_for_fee_view.id}")
    @physics_teacher1_session.assert_select "td",CourseIssueReply.model_name.human
    @physics_teacher1_session.assert_select "td",@course_issue_reply_for_fee_view.fee.value.to_s
    @physics_teacher1_session.assert_select "a[href=?]", tutorial_issue_reply_path(@tutorial_issue_reply_for_fee_view)
    @physics_teacher1_session.assert_select "td",TutorialIssueReply.model_name.human
    @physics_teacher1_session.assert_select "td",@tutorial_issue_reply_for_fee_view.fee.value.to_s
    @physics_teacher1_session.assert_select "a[href=?]",exercise_correction_path(@exercise_correction_for_fee_view)
    @physics_teacher1_session.assert_select "td",ExerciseCorrection.model_name.human
    @physics_teacher1_session.assert_select "td",@exercise_correction_for_fee_view.fee.value.to_s
    @physics_teacher1_session.assert_select "a[href=?]",homework_correction_path(@homework_correction_for_fee_view)
    @physics_teacher1_session.assert_select "td",HomeworkCorrection.model_name.human
    @physics_teacher1_session.assert_select "td",@homework_correction_for_fee_view.fee.value.to_s



  end

  test "teacher topics" do
    topic1 = topics(:topic1)
    topic2 = topics(:teacher_topic1)
    @teacher1_session.get topics_teacher_path(@teacher1)
    # @teacher1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    # @teacher1_session.assert_select "a[href=?]", topic_path(topic2), count:1

  end


  test "customized tutorial topics" do

    course_issue1     = topics(:customized_course_topic1)
    course_issue2     = topics(:customized_course_topic2)
    tutorial_issue1   = topics(:customized_tutorial_topic1)
    @teacher1_session.get customized_tutorial_topics_teacher_path(@teacher1)

    @teacher1_session.assert_select "a[href=?]", course_issue_path(course_issue1), count:1
    @teacher1_session.assert_select "a[href=?]", course_issue_path(course_issue2), count:1
    @teacher1_session.assert_select "a[href=?]", tutorial_issue_path(tutorial_issue1), count:1
    @teacher1_session.assert_response :success


  end

  test "teacher customized courses" do
    @teacher1_session.get customized_courses_teacher_path(@teacher1)
    @teacher1_session.assert_response :success

  end

  test "customized course homeworks" do
    @teacher1_session.get homeworks_teacher_path(@teacher1)
    @homework1  =  examinations(:homework1)
    @homework2  =  examinations(:homework2)
    @exercise1  =  examinations(:exercise_one)
    @teacher1_session.assert_select "a[href=?]",homework_path(@homework1),1
    @teacher1_session.assert_select "a[href=?]",homework_path(@homework2),1
    @teacher1_session.assert_select "a[href=?]",exercise_path(@exercise1),1


  end

  test "notification" do
    customized_course_action_notification_tutorial_issue_create               = notifications(:customized_course_action_notification_tutorial_issue_create)
    customized_course_action_notification_homework_solution_create            = notifications(:customized_course_action_notification_homework_solution_create)
    customized_course_action_notification_exercise_solution_create            = notifications(:customized_course_action_notification_exercise_solution_create)
    customized_course_action_notification_homework_correction_comment_create  = notifications(:customized_course_action_notification_homework_correction_comment_create)
    assert customized_course_action_notification_tutorial_issue_create.valid?
    assert customized_course_action_notification_homework_solution_create.valid?
    assert customized_course_action_notification_exercise_solution_create.valid?
    assert customized_course_action_notification_homework_correction_comment_create.valid?
    @teacher1_session.get notifications_teacher_path(@teacher1)
    @teacher1_session.assert_response :success
    @teacher1_session.assert_select 'a[href=?]',notification_path(customized_course_action_notification_tutorial_issue_create),1
    @teacher1_session.assert_select 'a[href=?]',notification_path(customized_course_action_notification_homework_solution_create),1
    @teacher1_session.assert_select 'a[href=?]',notification_path(customized_course_action_notification_exercise_solution_create),1
    @teacher1_session.assert_select 'a[href=?]',notification_path(customized_course_action_notification_homework_correction_comment_create),1
  end
end
