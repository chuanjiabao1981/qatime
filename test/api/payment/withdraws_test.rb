require 'test_helper'
class WithdrawsTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_balance)
    @student_token = api_login(@student, :app)
  end

  test 'get user withdraws' do
    get "/api/v1/payment/users/#{@student.id}/withdraws", {}, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 2, res['data'].count
  end

  test 'user create withdraws' do
    post "/api/v1/captcha", {send_to: @student.login_mobile, key: :withdraw_cash}
    assert_response :success
    captcha_manager = UserService::CaptchaManager.new(@student.login_mobile)
    captcha = captcha_manager.captcha_of(:withdraw_cash)

    post "/api/v1/payment/users/#{@student.id}/withdraws", { amount: 100, pay_type: :bank, account: 'test', name: 'test', verify: captcha}, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 'init', res['data']["status"]
    assert_equal 'bank', res['data']["pay_type"], "支付方式不正确"
  end

  test 'user cancel withdraw' do
    init_withdraw = @student.payment_withdraws.create(amount: 100, pay_type: 0, status: 0)
    put "/api/v1/payment/users/#{@student.id}/withdraws/#{init_withdraw.transaction_no}/cancel", {}, 'Remember-Token' => @student_token
    init_withdraw.reload
    assert_response :success
    assert init_withdraw.cancel?
  end
end
