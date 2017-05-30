require 'test_helper'
class WithdrawsTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_balance)
    @student_token = api_login(@student, :app)
  end

  test 'get user withdraws' do
    get "/api/v1/payment/users/#{@student.id}/withdraws", params: {}, headers: { 'Remember-Token' => @student_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 2, res['data'].count
  end

  test 'user create withdraws' do
    get "/api/v1/payment/users/#{@student.id}/withdraws/ticket_token", params: { password: '123123' }, headers: { 'Remember-Token' => @student_token }
    assert_response :success
    assert_equal 1, JSON.parse(response.body)['status'], JSON.parse(response.body)
    ticket = JSON.parse(response.body)['data']
    post  "/api/v1/payment/users/#{@student.id}/withdraws",
          params: { amount: 100, pay_type: :bank, account: 'test', name: 'test', ticket_token: ticket },
          headers: { 'Remember-Token' => @student_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 'init', res['data']["status"]
    assert_equal 'bank', res['data']["pay_type"], "支付方式不正确"
  end

  test 'user create withdraws error test' do
    get "/api/v1/payment/users/#{@student.id}/withdraws/ticket_token", params: { password: 'error_password' }, headers: { 'Remember-Token' => @student_token }
    assert_response :success
    assert_equal 0, JSON.parse(response.body)['status']
    assert_equal 2005, JSON.parse(response.body)['error']['code']
    get "/api/v1/payment/users/#{@student.id}/withdraws/ticket_token", params: { password: '123123' }, headers: { 'Remember-Token' => @student_token }
    assert_equal 1, JSON.parse(response.body)['status']
    ticket = JSON.parse(response.body)['data']
    post  "/api/v1/payment/users/#{@student.id}/withdraws",
          params: { amount: 100, pay_type: :bank, account: 'test', name: 'test', ticket_token: ticket },
          headers: { 'Remember-Token' => @student_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 'init', res['data']["status"]
    assert_equal 'bank', res['data']["pay_type"], "支付方式不正确"
  end

  test 'user cancel withdraw' do
    init_withdraw = @student.payment_withdraws.create(amount: 100, pay_type: 0, status: 0)
    put "/api/v1/payment/users/#{@student.id}/withdraws/#{init_withdraw.transaction_no}/cancel", params: {}, headers: { 'Remember-Token' => @student_token }
    init_withdraw.reload
    assert_response :success
    assert init_withdraw.canceled?
  end
end
