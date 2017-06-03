require 'test_helper'

class Qatime::InteractiveCoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end
  
  # 一对一搜索接口
  test 'interactive course search' do
    get "/api/v1/live_studio/interactive_courses/search"
    assert_request_success?
    assert_equal 3, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/interactive_courses/search", q: { grade_eq: '高一' }
    assert_request_success?
    assert_equal 2, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/interactive_courses/search", q: { subject_eq: '物理' }
    assert_request_success?
    assert_equal 1, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/interactive_courses/search", q: { subject_eq: '物理', grade_eq: '高二' }
    assert_request_success?
    assert_equal 0, @res['data'].count, '搜索结果不正确'
  end

  # 排序
  test 'interactive course sort' do
    get "/api/v1/live_studio/interactive_courses/search", sort_by: 'price'
    assert_request_success?
    assert_equal 700, @res['data'].first['price'].to_f, '按照价格排序不正确'

    get "/api/v1/live_studio/interactive_courses/search", sort_by: 'published_at.asc'
    assert_request_success?
    assert_equal '第2-2个一对一直播', @res['data'].last['name'], '按照发布时间排序不正确'
  end

  # 辅导班详情
  test 'interactive course deatil' do
    course1 = live_studio_interactive_courses(:interactive_course_one_2)
    course2 = live_studio_interactive_courses(:interactive_course_two_1)
    course3 = live_studio_interactive_courses(:interactive_course_three_1)
    get "/api/v1/live_studio/interactive_courses/#{course1.id}"
    assert_request_success?
    %w(name subject grade price status description lessons_count closed_lessons_count).each do |k|
      assert_includes @res['data'], k, "响应缺少字段 #{k}"
    end
    get "/api/v1/live_studio/interactive_courses/#{course2.id}"
    assert_request_success?
    get "/api/v1/live_studio/interactive_courses/#{course3.id}"
    assert_request_success?
  end

  test 'student buy a interactive course' do
    student = users(:student_one_with_course)
    @remember_token = api_login(student, :app)
    course = live_studio_interactive_courses(:interactive_course_two_3)
    assert_difference "Payment::Order.count", 1, "辅导班下单失败" do
      post "/api/v1/live_studio/interactive_courses/#{course.id}/orders", {pay_type: :weixin}, {'Remember-Token' => @remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
    end
    assert Payment::Order.last.weixin?, "支付方式记录错误"
    assert Payment::Order.last.source.student_app?, "订单来源错误"
  end

  # 一对一直播状态
  test 'visit realtime by student' do
    course = live_studio_interactive_courses(:interactive_course_three_2)

    get "/api/v1/live_studio/interactive_courses/#{course.id}/realtime", {}, { 'Remember-Token' => @student_remember_token }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 4, res['data'].size
  end

  # 一对一直播状态
  test 'visit realtime by teacher' do
    course = live_studio_interactive_courses(:interactive_course_three_2)
    get "/api/v1/live_studio/interactive_courses/#{course.id}/realtime", {}, { 'Remember-Token' => @remember_token }

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 4, res['data'].size
  end
end
