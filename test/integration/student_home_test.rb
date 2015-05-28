require 'test_helper'

class StudentrHomePageTest < ActionDispatch::IntegrationTest

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

end
