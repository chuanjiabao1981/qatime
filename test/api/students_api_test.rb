require 'test_helper'
class Qatime::StudentsAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student1)
    post '/api/v1/sessions', email: @student.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "GET /api/v1/students/:id/info returns student's info" do
    get "/api/v1/students/#{@student.id}/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 14, res['data'].size

    assert_equal @student.name, res['data']['name']
  end

  test "PUT /api/v1/students/:id update student and returns student's info" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/students/#{@student.id}", {name: "test_name", grade: "初一", avatar: img_file, gender: "male", birthday: "2000-01-01", desc: "desc test"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 14, res['data'].size

    @student.reload
    assert_equal @student.name, res['data']['name']
    assert_equal @student.grade, res['data']['grade']
    assert_equal @student.avatar_url, res['data']['avatar_url']
    assert_equal "2000-01-01", res['data']['birthday']
    assert_equal @student.desc, res['data']['desc']
  end
end
