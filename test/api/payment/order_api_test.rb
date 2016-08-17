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

end
