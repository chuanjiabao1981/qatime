require 'test_helper'
class Qatime::StudentsAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student1)
    post '/api/v1/sessions', email: @student.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @teacher_remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "GET /api/v1/students/:id/info returns student's info by student" do
    get "/api/v1/students/#{@student.id}/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 15, res['data'].size

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
    assert_equal 15, res['data'].size

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

  test 'GET /api/v1/student/schedule no params by student' do
    @student = users(:student_one_with_course)
    post '/api/v1/sessions', email: @student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/students/#{@student.id}/schedule", {}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert data.first['lessons'].count == 2, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/student/schedule returns error by teacher' do
    get "/api/v1/students/#{@teacher.id}/schedule", {}, 'Remember-Token' => @teacher_remember_token
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test 'GET /api/v1/student/:id/schedule has params by student' do
    @student = users(:student_one_with_course)
    post '/api/v1/sessions', email: @student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/students/#{@student.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert data.first['lessons'].count == 2, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/student/:id/schedule returns error by teacher' do
    get "/api/v1/students/#{@teacher.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @teacher_remember_token
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end
end
