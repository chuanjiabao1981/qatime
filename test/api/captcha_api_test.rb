require 'test_helper'
class Qatime::CaptchaAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "POST /api/v1/captcha send captcha" do
    post "/api/v1/captcha", {send_to: "15934836972", key: :register_captcha}

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
  end
end
