require 'test_helper'
class Qatime::OrderApiTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    post '/api/v1/sessions', email: @student.email,
         password: 'password',
         client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  test 'get order result' do
    order = payment_orders(:order_one)
    get "/api/v1/payment/orders/#{order.order_no}/result", {}, {'Remember-Token' => @remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
  end

  test 'get order list' do
    student = users(:student_with_order2)
    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'pc'
    remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/payment/orders", {}, {'Remember-Token' => remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 4, res['data'].size

    get "/api/v1/payment/orders", {cate: "unpaid"}, {'Remember-Token' => remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "unpaid", res['data'][0]['status']
  end

  test 'cancel order' do
    student = users(:student_with_order2)
    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'pc'
    remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/payment/orders", {cate: "unpaid"}, {'Remember-Token' => remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    order_id = res['data'][0]['id']

    patch "/api/v1/payment/orders/#{order_id}/cancel", {}, {'Remember-Token' => remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "canceled", res['data']['status']
  end
end
