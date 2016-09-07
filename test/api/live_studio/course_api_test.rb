require 'test_helper'

class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  test "get courses list of teacher" do
    teacher = users(:teacher1)
    get "/api/v1/live_studio/teachers/#{teacher.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
  end

  test "get courses list full of teacher" do
    teacher = users(:teacher1)

    get "/api/v1/live_studio/teachers/#{teacher.id}/courses/full", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
    assert_equal true, res['data'].first.has_key?('lessons')
  end

  test "get course detail of teacher" do
    teacher = users(:teacher1)
    course = teacher.live_studio_courses.last

    get "/api/v1/live_studio/teachers/#{teacher.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "get courses list of student" do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/live_studio/students/#{student.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
  end

  test "get course detail of student" do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = student.live_studio_courses.last

    get "/api/v1/live_studio/students/#{student.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "get courses list of search" do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/live_studio/courses", { page: 1, per_page: 10 }, {'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].first.has_key?('is_tasting')
  end

  test "get courses detail of search" do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = student.live_studio_courses.last

    get "/api/v1/live_studio/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
    assert_equal true, res['data'].has_key?('is_tasting')
  end

  test "taste courses for student" do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = LiveStudio::Course.preview.last

    get "/api/v1/live_studio/courses/#{course.id}/taste", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('status')
  end

  test 'get play info for course' do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = LiveStudio::Course.preview.last
    get "/api/v1/live_studio/courses/#{course.id}/play_info", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('chat_team')
  end

  test 'create course order' do
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = LiveStudio::Course.preview.last
    post "/api/v1/live_studio/courses/#{course.id}/orders", {pay_type: 1}, {'Remember-Token' => @remember_token}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 8, res['data'].size
  end

  test 'visit realtime' do
    course = live_studio_courses(:course_with_junior_teacher)
    student = users(:student_one_with_course)

    post '/api/v1/sessions', email: student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/live_studio/courses/#{course.id}/realtime", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 3, res['data'].size
  end



  test 'GET /api/v1/live_studio/students/schedule no params' do
    @student = users(:student_one_with_course)
    post '/api/v1/sessions', email: @student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert data.first['lessons'].count == 2, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/students/:id/schedule has params' do
    @student = users(:student_one_with_course)
    post '/api/v1/sessions', email: @student.email,
         password: 'password',
         client_type: 'app'
    @remember_token = JSON.parse(response.body)['data']['remember_token']

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert data.first['lessons'].count == 2, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end
end
