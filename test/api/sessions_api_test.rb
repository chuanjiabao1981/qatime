require 'test_helper'
class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "GET /api/v1/sessions returns user's remember_token" do
    teacher = users(:teacher1)
    post '/api/v1/sessions', email: '1@baidu.com',
                             password: '123456',
                             client_type: 'pc'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
    login_token = teacher.reload.login_tokens.find {|t| t.client_type == 'pc' }
    assert_not_nil login_token
    assert_equal login_token.digest_token, User.digest(res['data']['remember_token']), '状态码不对'
  end

  test "DELETE /api/v1/sessions returns user's remember_token" do
    post '/api/v1/sessions', email: '1@baidu.com',
                             password: '123456',
                             client_type: 'pc'
    remember_token = JSON.parse(response.body)['data']['remember_token']
    delete '/api/v1/sessions', {}, 'Remember-Token' => remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], '状态码不对'
  end
end
