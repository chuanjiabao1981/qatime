require 'test_helper'
class Qatime::PasswordAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "PUT /api/v1/password find password by email for student" do
    user = users(:student1)
    login_account = user.email

    post "/api/v1/captcha", params: { send_to: login_account, key: :get_password_back }
    put "/api/v1/password",
        params: { login_account: login_account, captcha_confirmation: "1234", password: "pa123456", password_confirmation: "pa123456" },
        headers: { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    user.reload
    assert_equal(true, user.authenticate('pa123456').present?, '找回密码错误')
  end

  test "PUT /api/v1/password find password by email for teacher" do
    user = users(:teacher1)
    login_account = user.email

    post "/api/v1/captcha", params: { send_to: login_account, key: :get_password_back }
    put "/api/v1/password",
        params: { login_account: login_account, captcha_confirmation: "1234", password: "pa123456", password_confirmation: "pa123456" },
        headers: { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    user.reload
    assert_equal(true, user.authenticate('pa123456').present?, '找回密码错误')
  end

  test "PUT /api/v1/password find password by login_mobile for student" do
    user = users(:student1)
    login_account = user.login_mobile

    post "/api/v1/captcha", params: { send_to: login_account, key: :get_password_back }

    put "/api/v1/password",
        params: { login_account: user.login_mobile, captcha_confirmation: "1234", password: "pa1234567", password_confirmation: "pa1234567" },
        headers: { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    user.reload
    assert_equal(true, user.authenticate('pa1234567').present?, '找回密码错误')
  end

  test "PUT /api/v1/password find password by login_mobile for teacher" do
    user = users(:teacher1)
    login_account = user.login_mobile

    post "/api/v1/captcha", params: { send_to: login_account, key: :get_password_back }

    put "/api/v1/password",
        params: { login_account: user.login_mobile, captcha_confirmation: "1234", password: "pa1234567", password_confirmation: "pa1234567" },
        headers: { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    user.reload
    assert_equal(true, user.authenticate('pa1234567').present?, '找回密码错误')
  end
end
