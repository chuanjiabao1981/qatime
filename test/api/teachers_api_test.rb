require 'test_helper'
class Qatime::TeachersAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @student = users(:student1)
    @student_remember_token = api_login(@student, :app)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  def app
    Rails.application
  end

  test "GET /api/v1/teachers/:id/info returns teacher's info by teacher" do
    get "/api/v1/teachers/#{@teacher.id}/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status'], "响应错误 #{res}"
    p res['data']
    assert_equal 19, res['data'].size

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
    assert_equal 19, res['data'].size

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
