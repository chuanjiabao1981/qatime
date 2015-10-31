require 'test_helper'

class StudentHomePageTest < ActionDispatch::IntegrationTest

  def setup
    @student1         = Student.find(users(:student1).id)
    @student1_session = log_in2_as(@student1)
  end

  def teardown
    @student1           = nil
    log_out2(@student1_session)
    @student1_session   = nil
  end


  test "student info" do
    @student1_session.get info_student_path(@student1)
    @student1_session.assert_select "a[href=?]", edit_student_path(@student1), count: 1
  end


  test "student fee info" do
    @student2               = Student.find(users(:student2).id)
    @student2_session       = log_in2_as(@student2)
    @student2_session.get info_student_path(@student2,fee: :y)


    @student2_session.assert_response :success

    @customized_tutorial_teacher_earnings_1 = customized_tutorials(:customized_tutorial_teacher_earnings_1)
    @course_issue_reply_for_fee_view        = replies(:course_issue_reply_for_fee_view)
    @tutorial_issue_reply_for_fee_view      = replies(:tutorial_issue_reply_for_fee_view)
    @exercise_correction_for_fee_view       = corrections(:exercise_correction_for_fee_view)
    @homework_correction_for_fee_view       = corrections(:homework_correction_for_fee_view)

    # @student2.account.consumption_records.each do |x|
    #   puts x.fee.to_json
    # end

    # puts @student2_session.response.body

    @student2_session.assert_select "a[href=?]", customized_tutorial_path(@customized_tutorial_teacher_earnings_1)
    @student2_session.assert_select "td",CustomizedTutorial.model_name.human
    @student2_session.assert_select "td",@customized_tutorial_teacher_earnings_1.fee.value.to_s
    @student2_session.assert_select "a[href=?]", course_issue_reply_path(@course_issue_reply_for_fee_view)
    @student2_session.assert_select "td",CourseIssueReply.model_name.human
    @student2_session.assert_select "td",@course_issue_reply_for_fee_view.fee.value.to_s
    @student2_session.assert_select "a[href=?]", tutorial_issue_reply_path(@tutorial_issue_reply_for_fee_view)
    @student2_session.assert_select "td",TutorialIssueReply.model_name.human
    @student2_session.assert_select "td",@tutorial_issue_reply_for_fee_view.fee.value.to_s
    @student2_session.assert_select "a[href=?]",exercise_correction_path(@exercise_correction_for_fee_view)
    @student2_session.assert_select "td",ExerciseCorrection.model_name.human
    @student2_session.assert_select "td",@exercise_correction_for_fee_view.fee.value.to_s
    @student2_session.assert_select "a[href=?]",homework_correction_path(@homework_correction_for_fee_view)
    @student2_session.assert_select "td",HomeworkCorrection.model_name.human
    @student2_session.assert_select "td",@homework_correction_for_fee_view.fee.value.to_s



  end

  test "student curriculums" do
    @student1_session.get curriculums_path
    @student1_session.assert_response :success
    @student1_session.assert_template 'curriculums/index'
  end

  test "student questions" do
    question1 = questions(:student1_question1)
    @student1_session.get questions_student_path(@student1)
    @student1_session.assert_select "a[href=?]", question_path(question1), count: 1
    @student1_session.assert_template 'students/questions'
    @student1_session.assert_response :success
  end

  test "student topics" do
    topic1 = topics(:topic1)
    topic2 = topics(:teacher_topic1)

    @student1_session.get topics_student_path(@student1)
    @student1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    @student1_session.assert_select "a[href=?]", topic_path(topic2), count:0

  end


  test "customized tutorial topics" do
    topic1 = topics(:customized_tutorial_topic1)
    topic2 = topics(:customized_tutorial_topic2)
    @student1_session.get customized_tutorial_topics_student_path(@student1)

    @student1_session.assert_select "a[href=?]", tutorial_issue_path(topic1), count:1
    @student1_session.assert_select "a[href=?]", course_issue_path(topic2), count:0
    @student1_session.assert_response :success


  end


  test "student customized courses" do
    @student1_session.get customized_courses_student_path(@student1)
    @student1_session.assert_select "a[href=?]", new_student_customized_course_path(@student1),count:0
    @student1_session.assert_response :success
  end

  test "customized course homeworks" do
    @student1_session.get homeworks_student_path(@student1)
    @homework1  =  examinations(:homework1)
    @homework2  =  examinations(:homework2)
    @exercise1  =  examinations(:exercise_one)
    @student1_session.assert_select "a[href=?]",homework_path(@homework1),1
    @student1_session.assert_select "a[href=?]",homework_path(@homework2),1
    @student1_session.assert_select "a[href=?]",exercise_path(@exercise1),1

  end

  test "notification" do
    customized_course_action_notification_tutorial_create     = notifications(:customized_course_action_notification_tutorial_create)
    assert customized_course_action_notification_tutorial_create.valid?
    @student1_session.get notifications_student_path(@student1)
    @student1_session.assert_response :success
    @student1_session.assert_select 'a[href=?]',notification_path(customized_course_action_notification_tutorial_create),1
  end
end
