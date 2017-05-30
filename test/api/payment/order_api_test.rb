require 'test_helper'
class Qatime::OrderApiTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

    @teacher = users(:teacher1)
    @teacher_remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  test 'get order result' do
    order = payment_transactions(:order_one)
    get "/api/v1/payment/orders/#{order.order_no}/result", params: {}, headers: { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
  end

  test 'get order result return error by teacher' do
    order = payment_transactions(:order_one)
    get "/api/v1/payment/orders/#{order.order_no}/result", params: {}, headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'get order list' do
    student = users(:student_with_order2)
    remember_token = api_login(student, :app)

    get "/api/v1/payment/orders", params: {}, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 4, res['data'].size

    get "/api/v1/payment/orders", params: { cate: "unpaid" }, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal "unpaid", res['data'][0]['status']
  end

  test 'get order list return error by teacher' do
    get "/api/v1/payment/orders", params: {}, headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']

    get "/api/v1/payment/orders", params: { cate: "unpaid" }, headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'cancel order' do
    student = users(:student_with_order2)
    remember_token = api_login(student, :app)

    get "/api/v1/payment/orders", params: { cate: "unpaid" }, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    order_id = res['data'][0]['id']

    put "/api/v1/payment/orders/#{order_id}/cancel", params: {}, headers: { 'Remember-Token' => remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口返回报错#{res}"
    assert_equal "canceled", res['data']['status']
  end

  test 'cancel order return error by teacher' do
    get "/api/v1/payment/orders", params: { cate: "unpaid" }, headers: { 'Remember-Token' => @teacher_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']

    order_id = Payment::Order.unpaid.first.id
    put "/api/v1/payment/orders/#{order_id}/cancel", params: {}, headers: { 'Remember-Token' => @teacher_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end
end
