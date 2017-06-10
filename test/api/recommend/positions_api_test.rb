require 'test_helper'
class Qatime::PositionApiTest < ActionDispatch::IntegrationTest
  def setup; end

  # 获取推荐位测试
  test 'get recommend positions' do
    get "/api/v1/recommend/positions"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 5, res['data'].count, "推荐返回错误"
  end

  # 测试获取名师推荐
  test 'get teacher recommend items for position' do
    get "/api/v1/recommend/positions/index_teacher_recommend/items"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 7, res['data'].count, "推荐返回错误"
    assert_includes res['data'].map {|item| item['type']}, "Recommend::TeacherItem", "没有正确返回名师推荐类型"
    assert_not_includes res['data'].map {|item| item['teacher']}, nil, "没有正确返回推荐教师信息"
  end

  # 测试获取辅导班推荐
  test 'get course recommend items for position' do
    get "/api/v1/recommend/positions/index_live_studio_course_recommend/items"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 2, res['data'].count, "推荐返回错误"
    assert_includes res['data'].map {|item| item['type']}, "Recommend::LiveStudioCourseItem", "没有正确返回辅导班推荐类型"
    assert_not_includes res['data'].map {|item| item['live_studio_course']}, nil, "没有正确返回推荐辅导班信息"
  end

  # 测试获取精选内容
  test 'get recommend choiceness items for position' do
    get "/api/v1/recommend/positions/index_choiceness_item/items"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 3, res['data'].count, "推荐返回错误"
    assert_includes res['data'].map {|item| item['type']}, "Recommend::ChoicenessItem", "没有正确返回辅导班推荐类型"
    assert res['data'].find {|item| item['live_studio_course']}.size > 0, "没有正确返回推荐辅导班信息"
    assert_includes res['data'].map {|item| item['tag_one']}, 'star_teacher'

    assert_includes res['data'].map {|item| item['target_type']}, "LiveStudio::Course", "没有正确返回课程类别"
    assert_includes res['data'].map {|item| item['target_type']}, "LiveStudio::InteractiveCourse", "没有正确返回课程类别"
    interactive_course_item = res['data'].find {|item| item['live_studio_interactive_course']}
    assert interactive_course_item['live_studio_interactive_course'].size > 0
  end

  # 测试专题内容
  test 'get recommend topic items for position' do
    get "/api/v1/recommend/positions/index_topic_item/items"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 1, res['data'].count, "推荐返回错误"
    assert_includes res['data'].map {|item| item['type']}, "Recommend::TopicItem", "没有正确返回推荐类型"
  end

  # 批量获取推荐
  test 'get recommend items for batch' do
    get "/api/v1/recommend/positions/index_live_studio_course_recommend-index_teacher_recommend/items/batch"
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_includes res['data'], "index_teacher_recommend", "批量获取推荐失败: 名师推荐丢失"
    assert_includes res['data'], "index_live_studio_course_recommend", "批量获取推荐失败: 辅导班推荐丢失"
  end

  # 根据城市测试获取辅导班推荐
  test 'get course recommend items for position by city_id' do
    city = City.find_by(name: '阳泉')
    get "/api/v1/recommend/positions/index_live_studio_course_recommend/items", city_id: city.id
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "接口响应错误 #{res}"
    assert_equal 2, res['data'].count, "推荐返回错误"
    assert_includes res['data'].map {|item| item['type']}, "Recommend::LiveStudioCourseItem", "没有正确返回辅导班推荐类型"
    assert_not_includes res['data'].map {|item| item['live_studio_course']}, nil, "没有正确返回推荐辅导班信息"
  end
end
