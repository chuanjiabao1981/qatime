require 'test_helper'
class Qatime::CashAccountApiTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_set_payment_password)
    @remember_token = api_login(@student, :app)

    @student2 = users(:student_update_payment_password)
    @remember_token2 = api_login(@student2, :app)

    @teacher = users(:teacher_get_back_payment_password)
    @teacher_remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 设置新的支付密码
  test 'student set payment password' do
    cash_account = @student.cash_account!

    post  '/api/v1/captcha',
          params: { send_to: @student.login_mobile, key: 'update_payment_pwd' }
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { password: 'password', captcha_confirmation: '1234' },
          headers: { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "获取token失败"

    new_password = Util.random_code(8)
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password",
          params: { ticket_token: res['data'], pament_password: new_password },
          headers: { 'Remember-Token' => @remember_token }
    assert cash_account.reload.authenticate(new_password), "设置支付密码失败"
  end

  # 通过当前支付密码重置支付密码
  test 'student update payment password' do
    cash_account = @student2.cash_account!

    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { current_pament_password: 'password' },
          headers: { 'Remember-Token' => @remember_token2 }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "获取token失败"

    new_password = Util.random_code(8)
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password",
          params: { ticket_token: res['data'], pament_password: new_password },
          headers: { 'Remember-Token' => @remember_token2 }
    assert cash_account.reload.authenticate(new_password), "设置支付密码失败"
  end

  # 找回支付密码测试
  test 'teacher get back payment password' do
    cash_account = @teacher.cash_account!

    post  '/api/v1/captcha',
          params: { send_to: @teacher.login_mobile, key: 'update_payment_pwd' }
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { password: 'password', captcha_confirmation: '1234' },
          headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "获取token失败"

    new_password = Util.random_code(8)
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password",
          params: { ticket_token: res['data'], pament_password: new_password },
          headers: { 'Remember-Token' => @teacher_remember_token }
    assert cash_account.reload.authenticate(new_password), "找回支付密码失败"
  end

  # 找回密码失败测试
  test 'teacher get payment password back error' do
    cash_account = @teacher.cash_account!

    # 登陆密码错误
    post  '/api/v1/captcha',
          params: { send_to: @teacher.login_mobile, key: 'update_payment_pwd' }
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { password: 'password_error', captcha_confirmation: '1234' },
          headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status'], "没有正确报错"
    assert_equal 2005, res['error']['code'], "错误码不正确"

    # 手机验证码错误
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { password: 'password', captcha_confirmation: '1235' },
          headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status'], "没有正确报错"
    assert_equal 2003, res['error']['code'], "错误码不正确"

    # 当前支付密码不正确
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password/ticket_token",
          params: { current_pament_password: 'password_error' },
          headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status'], "没有正确报错"
    assert_equal 2005, res['error']['code'], "错误码不正确"

    # 使用错误token
    new_password = Util.random_code(8)
    post  "/api/v1/payment/cash_accounts/#{cash_account.id}/password",
          params: { ticket_token: "this_is_a_invalid", pament_password: new_password },
          headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status'], "没有正确报错"
    assert_equal 2007, res['error']['code'], "错误码不正确"
  end
end
