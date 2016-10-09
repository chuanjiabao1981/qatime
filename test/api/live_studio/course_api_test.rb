require 'test_helper'

class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  test "get teacher courses list of teacher" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 5, res['data'].size
  end

  test "get teacher courses list return error of student" do
    get "/api/v1/live_studio/teachers/#{@student.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @student_remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "get teacher courses list full of teacher" do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/courses/full", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 5, res['data'].size
    assert_equal true, res['data'].first.has_key?('lessons')
  end

  test "get teacher courses list full return error of student" do
    get "/api/v1/live_studio/teachers/#{@student.id}/courses/full", { page: 1, per_page: 10 }, { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "get teacher course detail of teacher" do
    course = @teacher.live_studio_courses.last

    get "/api/v1/live_studio/teachers/#{@teacher.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "get teacher course detail return error of student" do
    course = @teacher.live_studio_courses.last

    get "/api/v1/live_studio/teachers/#{@student.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "get student courses list of student" do
    student = users(:student_one_with_course)

    @remember_token = api_login(student, :app)

    get "/api/v1/live_studio/students/#{student.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 2, res['data'].size
  end

  test "get student courses return error list of teacher" do
    get "/api/v1/live_studio/students/#{@teacher.id}/courses", { page: 1, per_page: 10 }, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "get student course detail of student" do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = student.live_studio_courses.last

    get "/api/v1/live_studio/students/#{student.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "get student course detail of teacher" do
    course = @teacher.live_studio_courses.last

    get "/api/v1/live_studio/students/#{@teacher.id}/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 0, res['status']
    assert_equal 1003, res['error']['code']
    assert_equal "无访问权限", res['error']['msg']
  end

  test "get courses list of search by student" do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)

    get "/api/v1/live_studio/courses", { page: 1, per_page: 10 }, {'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].first.has_key?('is_tasting')
  end

  test "get courses list of search by teacher" do
    get "/api/v1/live_studio/courses", { page: 1, per_page: 10 }, {'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
  end

  test "get courses detail of search by student" do
    course = @student.live_studio_courses.last

    get "/api/v1/live_studio/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @student_remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
    assert_equal true, res['data'].has_key?('is_tasting')
  end

  test "get courses detail of search by teacher" do
    course = @teacher.live_studio_courses.last
    get "/api/v1/live_studio/courses/#{course.id}", { page: 1, per_page: 10 }, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "taste courses for student" do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = LiveStudio::Course.preview.last

    get "/api/v1/live_studio/courses/#{course.id}/taste", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('status')
  end

  test 'get play info for course by teacher' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = LiveStudio::Course.preview.last
    get "/api/v1/live_studio/courses/#{course.id}/play_info", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('chat_team')
  end

  test 'get play info for course by student' do
    course = LiveStudio::Course.preview.last
    get "/api/v1/live_studio/courses/#{course.id}/play_info", {}, { 'Remember-Token' => @student_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('chat_team')
  end

  test 'create course order by student' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = LiveStudio::Course.preview.last
    assert_difference "Payment::Order.count", 1, "辅导班下单失败" do
      post "/api/v1/live_studio/courses/#{course.id}/orders", {pay_type: :weixin}, {'Remember-Token' => @remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
    end
  end

  test 'create course order return by teacher' do
    course = LiveStudio::Course.preview.last

    assert_difference "Payment::Order.count", 1, "辅导班下单失败" do
      post "/api/v1/live_studio/courses/#{course.id}/orders", {pay_type: :weixin}, {'Remember-Token' => @student_remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
    end
  end

  test 'visit realtime by student' do
    course = live_studio_courses(:course_with_junior_teacher)
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)

    get "/api/v1/live_studio/courses/#{course.id}/realtime", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 3, res['data'].size
  end

  test 'GET /api/v1/live_studio/students/schedule no params' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

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
    @remember_token = api_login(@student, :app)

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert data.first['lessons'].count == 2, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'visit realtime by teacher' do
    course = live_studio_courses(:course_with_junior_teacher)
    get "/api/v1/live_studio/courses/#{course.id}/realtime", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 3, res['data'].size
  end
end
