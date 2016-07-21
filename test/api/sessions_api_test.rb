require 'test_helper'
class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "GET /api/v1/sessions returns user's remember_token" do
    teacher = users(:teacher1)
    teacher.password = "pa123456"
    teacher.save!
    teacher.reload

    post '/api/v1/sessions', {
      email: teacher.email,
      password: teacher.password,
      client_type: 'pc'
    }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
    assert_equal teacher.login_tokens.where(client_type: LoginToken.client_types[:pc]).first.remember_token, res['data']['remember_token'], '状态码不对'
  end

  test "DELETE /api/v1/sessions returns user's remember_token" do
    teacher = users(:teacher1)
    remember_token = teacher.login_tokens.first.remember_token

    delete '/api/v1/sessions', {}, { 'Remember-Token': remember_token, 'Client-Type': 'pc' }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
  end
end
