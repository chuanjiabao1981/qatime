require 'test_helper'

class Qatime::CouponApiTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_set_payment_password)
    @remember_token = api_login(@student, :app)
  end

  test "POST /api/v1/payment/coupons/:code/verify verify coupon" do
    coupon = payment_coupons(:coupon_one)
    post "/api/v1/payment/coupons/" + coupon.code + "/verify"
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status'], "优惠码验证接口异常"
    assert res['data'].key?('price')
    assert res['data'].key?('code')
    assert_equal coupon.price, res['data']['price'].to_f
    assert_equal coupon.code, res['data']['code']
  end
end
