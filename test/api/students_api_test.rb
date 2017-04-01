require 'test_helper'
class Qatime::StudentsAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student1)
    @remember_token = api_login(@student, :app)

    @teacher = users(:teacher1)
    @teacher_remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  def app
    Rails.application
  end

  test "GET /api/v1/students/:id/info returns student's info by student" do
    get "/api/v1/students/#{@student.id}/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status'], "响应错误 #{res}"
    assert_equal 17, res['data'].size

    assert_equal @student.name, res['data']['name']
  end

  test "GET /api/v1/students/:id/info returns error by teacher" do
    get "/api/v1/students/#{@teacher.id}/info", {}, 'Remember-Token' => @teacher_remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "PUT /api/v1/students/:id update student and returns student's info by student" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/students/#{@student.id}", {name: "test_name", grade: "初一", avatar: img_file, gender: "male", birthday: "2000-01-01", desc: "desc test"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 17, res['data'].size

    @student.reload
    assert_equal @student.name, res['data']['name']
    assert_equal @student.grade, res['data']['grade']
    assert_equal @student.avatar_url, res['data']['avatar_url']
    assert_equal "2000-01-01", res['data']['birthday']
    assert_equal @student.desc, res['data']['desc']
  end

  test "PUT /api/v1/students/:id update student and returns error by teacher" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/students/#{@teacher.id}", {name: "test_name", grade: "初一", avatar: img_file, gender: "male", birthday: "2000-01-01", desc: "desc test"}, 'Remember-Token' => @teacher_remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'GET /api/v1/live_studio/student/schedule no params by student' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/student/schedule returns error by teacher' do
    get "/api/v1/live_studio/students/#{@teacher.id}/schedule", {}, 'Remember-Token' => @teacher_remember_token
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'GET /api/v1/live_studio/student/:id/schedule has params by student' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/student/:id/schedule returns error by teacher' do
    get "/api/v1/live_studio/students/#{@teacher.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @teacher_remember_token
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end
end
