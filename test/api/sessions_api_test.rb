class Qatime::CoursesAPITest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  test "GET /api/v1/sessions returns user's remember_token" do
    teacher = users(:teacher_one)
    teacher.password = "pa123456"
    teacher.save!
    teacher.reload

    post '/api/v1/sessions', {
      email: teacher.email,
      password: teacher.password,
      client_type: 'pc'
    }

    assert last_response.created?, "创建失败"

    res = JSON.parse(last_response.body)

    assert_equal 1, res['status'], '状态码不对'
    assert_equal teacher.login_tokens.where(client_type: LoginToken.client_types[:pc]).first.remember_token, res['data']['remember_token'], '状态码不对'
  end
end
