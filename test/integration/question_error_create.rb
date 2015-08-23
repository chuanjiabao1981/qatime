require 'test_helper'

class QuestionErrorCreateTest < ActionDispatch::IntegrationTest

  test "no learning plan new" do
    student           = Student.find(users(:no_learning_plan_student).id)
    student_session  = log_in2_as(student)
    student_session.get new_question_path
    student_session.assert_response :success
    student_session.assert_template 'questions/new'
    log_out2(student_session)
  end

  test "no learning_plan create" do
    student           = Student.find(users(:no_learning_plan_student).id)
    student_session   = log_in2_as(student)
    learning_plan     = learning_plans(:h_math_learning_plan)

    student_session.post questions_path,question:{learning_plan_id:learning_plan.id,
                                                  teachers: learning_plan.teacher_ids,
                                                  title: "测试下都要那些内容的json串",
                                                  content: "测试下都要那些内容的json串测试下都要那"
                                                 }
    student_session.assert_redirected_to get_home_url(student)
    log_out2(student_session)

  end

  test "input error not set learning_plan id" do
    student           = Student.find(users(:student1).id)
    student_session   = log_in2_as(student)
    student_session.post questions_path,question:{learning_plan_id: student.learning_plans.first.id,
                                                  title: "测试下都要那些内容的json串",
                                                  content: "测试下都要那些内容的json串测试下都要那"
                                       }
    student_session.assert_template 'questions/new'
    student_session.assert_response :success
    log_out2(student_session)

  end

  test "no permission edit" do
    question = questions(:student1_question1)
    user         = Student.find(users(:student2).id)
    user_session = log_in2_as(user)

    user_session.get edit_question_path(question)
    user_session.assert_redirected_to get_home_url(user)

  end

  test "no permission update" do
    question = questions(:student1_question1)
    user         = Student.find(users(:student2).id)
    user_session = log_in2_as(user)

    user_session.put question_path(question),question:{title: "试着修改一下title 虽然我没有权限"}
    user_session.assert_redirected_to get_home_url(user)

  end

  test "no permission destroy" do
    question = questions(:student1_question1)
    user         = Student.find(users(:student2).id)
    user_session = log_in2_as(user)

    user_session.delete question_path(question)
    user_session.assert_redirected_to get_home_url(user)
  end

end