require 'test_helper'
class Qatime::UsersAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student1)
    post '/api/v1/sessions',
         params: {
           email: @student.email,
           password: 'password',
           client_type: 'pc',
           client_cate: 'student_client'
         }
    @student_remember_token = JSON.parse(response.body)['data']['remember_token']

    @teacher = users(:teacher1)
    post '/api/v1/sessions',
         params: {
           email: @teacher.email,
           password: 'password',
           client_type: 'pc',
           client_cate: 'teacher_live'
         }
    @teacher_remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "PUT /api/v1/users/:id/email update email by student" do
    post "/api/v1/captcha", params: { send_to: @student.login_mobile, key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha/verify", params: { send_to: @student.login_mobile, captcha: '1234' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha", params: { send_to: "user_update_email@student.com", key: :change_email_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    put "/api/v1/users/#{@student.id}/email",
        params: { email: "user_update_email@student.com", captcha_confirmation: "1234" },
        headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "user_update_email@student.com", res['data']['email']
  end

  test "PUT /api/v1/users/:id/email update email by teacher" do
    post "/api/v1/captcha", params: { send_to: @teacher.login_mobile, key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha/verify", params: { send_to: @teacher.login_mobile, captcha: '1234' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha", params: { send_to: "user_update_email@student.com", key: :change_email_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    put "/api/v1/users/#{@teacher.id}/email",
        params: { email: "user_update_email@student.com", captcha_confirmation: "1234" },
        headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "user_update_email@student.com", res['data']['email']
  end

  test "PUT /api/v1/users/:id/login_mobile update login_mobile by student" do
    post "/api/v1/captcha", params: { send_to: @student.login_mobile, key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha/verify", params: { send_to: @student.login_mobile, captcha: '1234' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha", params: { send_to: "13892920102", key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    put "/api/v1/users/#{@student.id}/login_mobile",
        params: { login_mobile: "13892920102", captcha_confirmation: "1234" },
        headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "13892920102", res['data']['login_mobile']
  end

  test "PUT /api/v1/users/:id/login_mobile update login_mobile by teacher" do
    post "/api/v1/captcha", params: { send_to: @teacher.login_mobile, key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应不正确 #{res}"
    assert_nil res['data']

    post "/api/v1/captcha/verify", params: { send_to: @teacher.login_mobile, captcha: '1234' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    post "/api/v1/captcha", params: { send_to: "13892920102", key: :send_captcha }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']

    put "/api/v1/users/#{@teacher.id}/login_mobile",
        params: { login_mobile: "13892920102", captcha_confirmation: "1234" },
        headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "13892920102", res['data']['login_mobile']
  end

  test "PUT /api/v1/users/:id/password update password by student" do
    put "/api/v1/users/#{@student.id}/password",
        params: { current_password: "password", password: "pa123456", password_confirmation: "pa123456" },
        headers: { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    @student.reload
    assert_equal(true, @student.authenticate('pa123456').present?, '更新密码错误')
  end

  test "PUT /api/v1/users/:id/password update password by teacher" do
    put "/api/v1/users/#{@teacher.id}/password",
        params: { current_password: "password", password: "pa123456", password_confirmation: "pa123456" },
        headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    @teacher.reload
    assert_equal(true, @teacher.authenticate('pa123456').present?, '更新密码错误')
  end
end
