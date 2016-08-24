require 'test_helper'
class Qatime::UsersAPITest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:student1)
    post '/api/v1/sessions', email: @user.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "PUT /api/v1/users/:id/email update email" do
    post "/api/v1/captcha", {send_to: @user.login_mobile, key: :send_captcha}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    post "/api/v1/captcha/verify", {send_to: @user.login_mobile, captcha: '1234'}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    post "/api/v1/captcha", {send_to: "user_update_email@user.com", key: :change_email_captcha}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    put "/api/v1/users/#{@user.id}/email", {email: "user_update_email@user.com", captcha_confirmation: "1234"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "user_update_email@user.com", res['data']['email']
  end

  test "PUT /api/v1/users/:id/login_mobile update login_mobile" do
    post "/api/v1/captcha", {send_to: @user.login_mobile, key: :send_captcha}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    post "/api/v1/captcha/verify", {send_to: @user.login_mobile, captcha: '1234'}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    post "/api/v1/captcha", {send_to: "13892920102", key: :send_captcha}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal nil, res['data']

    put "/api/v1/users/#{@user.id}/login_mobile", {login_mobile: "13892920102", captcha_confirmation: "1234"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "13892920102", res['data']['login_mobile']
  end

  test "PUT /api/v1/users/:id/password update password" do
    put "/api/v1/users/#{@user.id}/password", {current_password: "password", password: "pa123456", password_confirmation: "pa123456"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    @user.reload
    assert_equal(true, @user.authenticate('pa123456').present?, '更新密码错误')
  end
end
