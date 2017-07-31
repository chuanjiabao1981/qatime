require 'test_helper'

class Qatime::GroupAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  # 专属课搜索接口
  test "customized group search" do
    get "/api/v1/live_studio/customized_groups/search", { page: 1, per_page: 10 }
    assert_request_success?
    assert_equal 10, @res['data'].count, "专属课搜索结果不正确"
    get "/api/v1/live_studio/customized_groups/search", { page: 1, per_page: 10, q: { subject_eq: '英语' } }
    assert_request_success?
    assert_equal 3, @res['data'].count, "科目过滤不生效 #{@res['data'].map {|g| g['subject']}}"
    get "/api/v1/live_studio/customized_groups/search", { page: 1, per_page: 10, q: { subject_eq: '英语', grade_eq: '高三' } }
    assert_request_success?
    assert_equal 1, @res['data'].count, "年级过滤不生效"
  end

  # 专属课搜索接口
  test "customized group detail" do
    group = live_studio_groups(:published_group1)
    # 未登录
    get "/api/v1/live_studio/customized_groups/#{group.id}/detail"
    assert_request_success?
    assert_equal group.name, @res['data']['customized_group']['name'], "专属课详情获取失败"
    assert_nil @res['data']['ticket'], "未登录ticket返回错误"
    # 未购买
    get "/api/v1/live_studio/customized_groups/#{group.id}/detail", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal group.name, @res['data']['customized_group']['name'], "专属课详情获取失败"
    assert_nil @res['data']['ticket'], "未购买ticket返回错误"
    # 已购买
    group2 = live_studio_groups(:published_group2)
    get "/api/v1/live_studio/customized_groups/#{group2.id}/detail", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal group2.name, @res['data']['customized_group']['name'], "专属课详情获取失败"
    assert_not_nil @res['data']['ticket'], "已购买ticket返回错误"
  end

  # 直播观看信息
  test "customized group play detail" do
    group = live_studio_groups(:published_group2)
    get "/api/v1/live_studio/customized_groups/#{group.id}/play", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_not_nil @res['data']['chat_team'], "聊天群组信息没有正确返回"
    # TODO 填充测试数据
    assert_not_nil @res['data']['board_pull_stream'], "白板拉流地址没有返回"
    assert_not_nil @res['data']['camera_pull_stream'], "摄像头拉流地址没有返回"
  end

  # 实时直播状态
  test "customized group realtime info" do
    group = live_studio_groups(:published_group2)
    get "/api/v1/live_studio/customized_groups/#{group.id}/realtime", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal "LiveStudio::ScheduledLesson", @res['data']['live_info']['type']
  end
end
