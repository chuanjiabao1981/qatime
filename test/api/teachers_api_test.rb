require 'test_helper'
class Qatime::TeachersAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    @student = users(:student1)
    post '/api/v1/sessions', email: @student.email,
                             password: 'password',
                             client_type: 'pc'
    @student_remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "GET /api/v1/teachers/:id/info returns teacher's info by teacher" do
    get "/api/v1/teachers/#{@teacher.id}/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 18, res['data'].size

    assert_equal @teacher.name, res['data']['name']
  end

  test "GET /api/v1/teachers/:id/info returns error info by student" do
    get "/api/v1/teachers/#{@student.id}/info", {}, 'Remember-Token' => @student_remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "PUT /api/v1/teachers/:id updat teacher and returns teacher's info by teacher" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/teachers/#{@teacher.id}", {name: "test_name", avatar: img_file, gender: "male", birthday: "1999-01-01", desc: "desc test"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 18, res['data'].size

    @teacher.reload
    assert_equal @teacher.name, res['data']['name']
    assert_equal @teacher.avatar_url, res['data']['avatar_url']
    assert_equal "1999-01-01", res['data']['birthday']
    assert_equal @teacher.desc, res['data']['desc']
  end

  test "PUT /api/v1/teachers/:id updat teacher and returns error info by student" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/teachers/#{@student.id}", {name: "test_name", avatar: img_file, gender: "male", birthday: "1999-01-01", desc: "desc test"}, 'Remember-Token' => @student_remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end
end
