require 'test_helper'
class ItunesProductsTest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_recharge)
    @student_token = api_login(@student, :app)
  end

  test 'get all available products' do
    get "/api/v1/payment/itunes_products", {}, 'Remember-Token' => @student_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应状态不正确 #{res}"
    assert_equal 6, res['data'].count, "商品数量不正确"
  end
end
