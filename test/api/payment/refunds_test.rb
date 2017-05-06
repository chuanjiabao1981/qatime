require 'test_helper'
class RefundsTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_order_for_refund)
    @student_token = api_login(@student, :app)
  end

  test 'get refund info' do
    order = payment_transactions(:order_for_refund)
    get "/api/v1/payment/users/#{@student.id}/refunds/info", {order_id: order.transaction_no}, 'Remember-Token' => @student_token
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 1, res['status']
    assert_equal 'init', res['data']['status']
  end

  test 'create refund test ' do
    order = payment_transactions(:order_for_refund)
    assert_difference 'Payment::Refund.count', +1 do
      post "/api/v1/payment/users/#{@student.id}/refunds", {order_id: order.transaction_no, reason: 'reason test'}, 'Remember-Token' => @student_token
    end
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 1, res['status']
    assert_equal 'init', res['data']['status']
    assert_equal 'reason test', res['data']['reason']
    assert_equal Payment::Refund.last.amount, order.amount-LiveService::OrderDirector.new(order).consumed_amount
  end

  test 'refund list test ' do
    get "/api/v1/payment/users/#{@student.id}/refunds", {}, 'Remember-Token' => @student_token
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 1, res['status']
    assert_equal 4, res['data'].count, "返回数据不正确 #{res['data']}"
  end

  test 'create cancel refund test' do
    order = payment_transactions(:order_for_refund2)
    put "/api/v1/payment/users/#{@student.id}/refunds/#{order.transaction_no}/cancel",{},'Remember-Token' => @student_token
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 1, res['status'], "返回状态错误 #{res}"
    assert_equal 'canceled', res['data']['status']
  end
end
