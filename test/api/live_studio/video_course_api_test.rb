require 'test_helper'

class Qatime::VideoCoursesAPITest < ActionDispatch::IntegrationTest
  # 搜索接口
  test 'video course search' do
    get "/api/v1/live_studio/video_courses/search"
    assert_request_success?
    assert_equal 3, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { grade_eq: '高一' }
    assert_request_success?
    assert_equal 2, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { subject_eq: '物理' }
    assert_request_success?
    assert_equal 1, @res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { subject_eq: '物理', grade_eq: '高二' }
    assert_request_success?
    assert_equal 0, @res['data'].count, '搜索结果不正确'
  end

  # 排序
  test 'video course sort' do
    get "/api/v1/live_studio/video_courses/search", sort_by: 'price'
    assert_request_success?
    assert_equal 700, @res['data'].first['price'].to_f, '按照价格排序不正确'

    get "/api/v1/live_studio/video_courses/search", sort_by: 'published_at.asc'
    assert_request_success?
    assert_equal '第2-2个一对一直播', @res['data'].last['name'], '按照发布时间排序不正确'
  end

  # 详情
  test 'video course deatil' do
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


end
