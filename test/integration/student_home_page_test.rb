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
    @student1_session.assert_select "a[href=?]", homework_path(@homework1),1
    @student1_session.assert_select "a[href=?]", homework_path(@homework2),1
    @student1_session.assert_select "a[href=?]", exercise_path(@exercise1),1

  end

  test "notification" do
    customized_course_action_notification_tutorial_create                   = notifications(:customized_course_action_notification_tutorial_create)
    customized_course_action_notification_exercise_create                   = notifications(:customized_course_action_notification_exercise_create)
    customized_course_action_notification_tutorial_issue_reply_create       = notifications(:customized_course_action_notification_tutorial_issue_reply_create)
    customized_course_action_notification_homework_create                   = notifications(:customized_course_action_notification_homework_create)
    customized_course_action_notification_exercise_correction_create        = notifications(:customized_course_action_notification_exercise_correction_create)
    customized_course_action_notification_homework_correction_create        = notifications(:customized_course_action_notification_homework_correction_create)
    customized_course_action_notification_customized_course_message1_create = notifications(:customized_course_action_notification_customized_course_message1_create)
    customized_course_action_notification_solution_state_change             = notifications(:customized_course_action_notification_solution_state_change)

    assert customized_course_action_notification_tutorial_create.valid?
    assert customized_course_action_notification_exercise_create.valid?
    assert customized_course_action_notification_tutorial_issue_reply_create.valid?
    assert customized_course_action_notification_homework_create.valid?
    assert customized_course_action_notification_exercise_correction_create.valid?
    assert customized_course_action_notification_homework_correction_create.valid?
    assert customized_course_action_notification_customized_course_message1_create.valid?
    assert customized_course_action_notification_solution_state_change.valid?

    @student1_session.get user_notifications_path(@student1)
    @student1_session.assert_response :success
    rt = main_app.send("#{customized_course_action_notification_tutorial_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_tutorial_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_tutorial_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_exercise_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_exercise_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_exercise_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_tutorial_issue_reply_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_tutorial_issue_reply_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_tutorial_issue_reply_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_homework_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_homework_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_homework_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_exercise_correction_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_exercise_correction_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_exercise_correction_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_homework_correction_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_homework_correction_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_homework_correction_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_customized_course_message1_create.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_customized_course_message1_create.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_customized_course_message1_create, rt: rt), 1
    rt = main_app.send("#{customized_course_action_notification_solution_state_change.notificationable.actionable.model_name.singular_route_key}_path",
                       customized_course_action_notification_solution_state_change.notificationable.actionable)
    @student1_session.assert_select 'a[href=?]', notification_path(customized_course_action_notification_solution_state_change, rt: rt), 1
  end
end
