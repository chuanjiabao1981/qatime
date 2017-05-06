require 'test_helper'
class Qatime::CaptchaAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "POST /api/v1/captcha send captcha" do
    post "/api/v1/captcha", {send_to: "13892920110", key: :send_captcha}
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_nil res['data']
  end

  test "POST /api/v1/captcha/verify verify captcha" do
    post "/api/v1/captcha", {send_to: "13892920110", key: :send_captcha}
    post "/api/v1/captcha/verify", {send_to: "13892920110", captcha: '1234'}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_nil res['data']
  end
end
