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
    assert_equal 10, res['data'].size
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
    assert_equal 10, res['data'].size
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
    assert_equal 1, res['data'].size
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
    assert_equal 1, res['status'], "返回数据错误#{res}"
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

    assert_equal 1, res['status'], "返回数据错误#{res}"
    assert_equal true, res['data'].has_key?('lessons')
  end

  test "taste courses for student" do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    @remember_token = JSON.parse(response.body)['data']['remember_token']
    course = LiveStudio::Course.published.where("taste_count < 1").last

    get "/api/v1/live_studio/courses/#{course.id}/taste", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 3004, res['error']['code'], '未报试听错误'

    course = live_studio_courses(:course_for_taste_overflow)
    get "/api/v1/live_studio/courses/#{course.id}/taste", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 0, res['status']
    assert_equal 3004, res['error']['code'], '未报试听错误'

    course = live_studio_courses(:course_with_lessons)
    stub_chat_account

    get "/api/v1/live_studio/courses/#{course.id}/taste", {}, { 'Remember-Token' => @remember_token }
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应出错 #{res}"
    assert_equal true, res['data'].has_key?('status')
  end

  test 'get play info for course by teacher' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = LiveStudio::Course.published.last
    get "/api/v1/live_studio/courses/#{course.id}/play_info", {}, { 'Remember-Token' => @remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('chat_team')
  end

  test 'get play info for course by student' do
    course = LiveStudio::Course.published.last
    get "/api/v1/live_studio/courses/#{course.id}/play_info", {}, { 'Remember-Token' => @student_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal true, res['data'].has_key?('chat_team')
  end

  test 'create course order by student' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = LiveStudio::Course.published.last
    assert_difference "Payment::Order.count", 1, "辅导班下单失败" do
      post "/api/v1/live_studio/courses/#{course.id}/orders", {pay_type: :weixin}, {'Remember-Token' => @remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
    end
  end

  test 'create course order by student use coupon' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = LiveStudio::Course.published.last
    coupon = payment_coupons(:coupon_one)

    assert_difference "Payment::Order.count", 1, "辅导班使用优惠码下单失败" do
      post "/api/v1/live_studio/courses/#{course.id}/orders", {pay_type: :weixin, coupon_code: coupon.code}, {'Remember-Token' => @remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
      res = JSON.parse(response.body)
      assert res['data'].has_key?('coupon_code')
      assert_equal course.coupon_price(coupon), res['data']['amount'].to_f, "优惠价格未扣除"
    end
  end

  test 'create course order return by teacher' do
    course = LiveStudio::Course.published.last

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
    assert_equal 4, res['data'].size
  end

  test 'GET /api/v1/live_studio/students/schedule no params' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 3, data.first['lessons'].count, '返回课程数量不对'
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
    assert_equal 3, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/students/:id/schedule week' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)

    get "/api/v1/live_studio/students/#{@student.id}/schedule", {week: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 3, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_week.to_date && return_date <= Time.now.end_of_week.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/teachers/schedule no params' do
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)

    get "/api/v1/live_studio/teachers/#{@teacher.id}/schedule", {}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/teachers/:id/schedule has params' do
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)

    get "/api/v1/live_studio/teachers/#{@teacher.id}/schedule", {month: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'
  end

  test 'GET /api/v1/live_studio/teachers/:id/schedule week' do
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)

    get "/api/v1/live_studio/teachers/#{@teacher.id}/schedule", {week: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    data = JSON.parse(response.body)['data']
    assert_response :success
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_week.to_date && return_date <= Time.now.end_of_week.to_date, '返回数据日期不正确'
  end

  test 'visit realtime by teacher' do
    course = live_studio_courses(:course_with_junior_teacher)
    get "/api/v1/live_studio/courses/#{course.id}/realtime", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 4, res['data'].size
  end

  test 'student get replays list' do
    @student = users(:student_one_with_course)
    @remember_token = api_login(@student, :app)
    @course = live_studio_courses(:course_for_channel)
    get "/api/v1/live_studio/courses/#{@course.id}/replays", {}, 'Remember-Token' => @remember_token
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal Array, res['data']['lessons'].class
  end

  # 最新发布和最近开课接口
  test 'get courses rank' do
    get '/api/v1/live_studio/courses/rank/published_rank,%20start_rank'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "请求出错 #{res}"
    assert_not_nil res['data']['published_rank']
    assert_not_nil res['data']['start_rank']
  end

  test 'get courses rank_all' do
    get '/api/v1/live_studio/courses/rank_all/all_published_rank'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "请求出错 #{res}"
    assert_not_nil res['data']['all_published_rank']
  end

  test 'get all tags' do
    get '/api/v1/app_constant/tags'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "请求出错 #{res}"
    assert_equal res['data'].count, 19, "标签获取失败"
  end

  # 新的搜索接口
  test 'search courses with tags' do
    get '/api/v1/live_studio/courses/search', range: '1_months'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "请求出错 #{res}"
    assert_equal res['data'].count, 4, "标签获取失败"
  end

  # 免费课程
  test 'get free courses' do
    get '/api/v1/live_studio/free_courses'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "请求出错 #{res}"
    assert res['data'][0].key?('product_type')
    assert res['data'][0].key?('product')
  end
end
