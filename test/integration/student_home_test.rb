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
    @customized_tutorial_teacher_earnings_1 = customized_tutorials(:customized_tutorial_teacher_earnings_1)
    @exercise_fee_solution_one              = solutions(:exercise_fee_solution_one)
    @reply_fee_tutorial_topic               = topics(:reply_fee_tutorial_topic)
    @solution_for_homework_correction_fee   = solutions(:solution_for_homework_correction_fee)

    assert @student2.account.consumption_records.length == 4
    # @student2.account.consumption_records.each do |e|
    #   puts e.fee.to_json
    # end
    @student2_session.assert_response :success
    @student2_session.assert_select "a[href=?]",customized_tutorial_path(@customized_tutorial_teacher_earnings_1)
    @student2_session.assert_select "a[href=?]",solution_path(@exercise_fee_solution_one)
    @student2_session.assert_select "a[href=?]",topic_path(@reply_fee_tutorial_topic)
    @student2_session.assert_select "a[href=?]",solution_path(@solution_for_homework_correction_fee)

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

    @student1_session.assert_select "a[href=?]", topic_path(topic1), count:1
    @student1_session.assert_select "a[href=?]", topic_path(topic2), count:0
    @student1_session.assert_response :success


  end


  test "student customized courses" do
    @student1_session.get customized_courses_student_path(@student1)
    @student1_session.assert_select "a[href=?]", new_student_customized_course_path(@student1),count:0
    @student1_session.assert_response :success
  end

end
