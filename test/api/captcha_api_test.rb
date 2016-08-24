require 'test_helper'
class Qatime::CaptchaAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "POST /api/v1/captcha returns teacher's info" do
    post "/api/v1/captcha", {send_to: "15934836972", key: :register_captcha}

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
  end
end
