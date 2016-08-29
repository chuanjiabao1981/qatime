require 'test_helper'
class Qatime::CaptchaAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "GET /api/v1/app_constant get app_constant" do
    get "/api/v1/app_constant"
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 5, res['data'].size
  end
end
