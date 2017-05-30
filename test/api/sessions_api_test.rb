require 'test_helper'
class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "POST /api/v1/sessions as email returns teacher's remember_token" do
    teacher = users(:teacher1)
    api_login_by_pc teacher
    res = JSON.parse(response.body)
    login_token = teacher.reload.login_tokens.find {|t| t.client_type == 'pc' }
    assert_not_nil login_token
    assert_equal login_token.digest_token, User.digest(res['data']['remember_token']), '状态码不对'
  end

  # test "POST /api/v1/sessions as email returns student's remember_token" do
  #   student = users(:student1)
  #   api_login_by_pc student
  #   res = JSON.parse(response.body)
  #   login_token = student.reload.login_tokens.find {|t| t.client_type == 'pc' }
  #   assert_not_nil login_token
  #   assert_equal login_token.digest_token, User.digest(res['data']['remember_token']), '状态码不对'
  # end

  test "POST /api/v1/sessions as login_account returns student's remember_token" do
    student = users(:update_email_student)
    api_login_by_pc student
    res = JSON.parse(response.body)
    login_token = student.reload.login_tokens.find {|t| t.client_type == 'pc' }
    assert_not_nil login_token
    assert_equal login_token.digest_token, User.digest(res['data']['remember_token']), '状态码不对'
  end

  test "POST /api/v1/sessions as login_account returns teacher's remember_token" do
    teacher = users(:teacher_update_password)
    api_login_by_pc teacher
    res = JSON.parse(response.body)
    login_token = teacher.reload.login_tokens.find {|t| t.client_type == 'pc' }
    assert_not_nil login_token
    assert_equal login_token.digest_token, User.digest(res['data']['remember_token']), '状态码不对'
  end

  test "POST /api/v1/sessions as student login for teacher's client raise error 2002" do
    teacher = users(:teacher_update_password)
    post '/api/v1/sessions',
         params: {
           login_account: teacher.login_account,
           password: 'password',
           client_type: "pc",
           client_cate: "student_client"
         }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status'], '状态码不对'
    assert_equal 2002, res['error']['code']
  end

  test "DELETE /api/v1/sessions returns student's remember_token" do
    student = users(:update_email_student)

    api_login_by_pc(student)
    remember_token = JSON.parse(response.body)['data']['remember_token']
    delete '/api/v1/sessions', params: {}, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
  end

  test "DELETE /api/v1/sessions returns teacher's remember_token" do
    teacher = users(:teacher_update_password)
    api_login_by_pc(teacher)
    remember_token = JSON.parse(response.body)['data']['remember_token']
    delete '/api/v1/sessions', params: {}, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
  end
end
