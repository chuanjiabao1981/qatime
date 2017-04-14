require 'test_helper'

class Qatime::VideoCoursesAPITest < ActionDispatch::IntegrationTest
  # 搜索接口
  test 'video course search' do
    get "/api/v1/live_studio/video_courses/search"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal LiveStudio::VideoCourse.for_sell.count, res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { grade_eq: '高一' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { subject_eq: '语文' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { subject_eq: '数学', grade_eq: '高一' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", q: { sell_type_eq: 'charge' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['data'].count, '搜索结果不正确'

    get "/api/v1/live_studio/video_courses/search", sort_by: 'price'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 300, res['data'].first['price'].to_f, '按照价格降序排序不正确'
  end

  # 详情
  test 'video course detail' do
    video_course1 = live_studio_video_courses(:published_video_course1)
    get "/api/v1/live_studio/video_courses/#{video_course1.id}"
    assert_response :success
    res = JSON.parse(response.body)
    %w(name teacher subject grade price status description video_lessons_count video_lessons sell_type).each do |k|
      assert_includes res['data'], k, "响应缺少字段 #{k}"
    end
  end


end
