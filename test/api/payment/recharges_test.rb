require 'test_helper'
class RechargeApiTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_recharge)
    @student_token = api_login(@student, :app)
  end

  test 'get user recharges' do
    get "/api/v1/payment/users/#{@student.id}/recharges", {}, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 3, res['data'].count
    assert_includes res['data'].map {|recharge| recharge['status']}, 'unpaid', "没有正确显示未支付充值记录"
    assert_includes res['data'].map {|recharge| recharge['status']}, 'paid', "没有正确显示已支付充值记录"
  end

  test 'user alipay recharge' do
    post "/api/v1/payment/users/#{@student.id}/recharges", { amount: 30, pay_type: :alipay }, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_not_empty res['data']["id"], "没有正确返回订单号"
    assert_equal 30, res['data']["amount"].to_f, "充值金额不正确"
    assert_equal 'unpaid', res['data']["status"], "充值状态不正确"
    assert_equal 'alipay', res['data']["pay_type"], "支付方式不正确"
    assert_equal 'app', res['data']["source"], "下单来源不正确"
  end

  test 'user weixin recharge' do
    post "/api/v1/payment/users/#{@student.id}/recharges", { amount: 30, pay_type: :weixin }, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 'unpaid', res['data']["status"], "充值状态不正确"
    assert_equal 'weixin', res['data']["pay_type"], "支付方式不正确"
  end

  test 'user offline recharge' do
    post "/api/v1/payment/users/#{@student.id}/recharges", { amount: 10, pay_type: :offline }, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 'unpaid', res['data']["status"], "充值状态不正确"
    assert_equal 'offline', res['data']["pay_type"], "支付方式不正确"
  end
end
