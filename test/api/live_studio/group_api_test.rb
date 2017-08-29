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
    assert_equal 4, @res['data'].count, "科目过滤不生效 #{@res['data'].map {|g| g['subject']}}"
    get "/api/v1/live_studio/customized_groups/search", { page: 1, per_page: 10, q: { subject_eq: '英语', grade_eq: '高三' } }
    assert_request_success?
    assert_equal 2, @res['data'].count, "年级过滤不生效"
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
    assert_not_nil @res['data']['customized_group']['chat_team'], "聊天群组信息没有正确返回"
    assert_not_nil @res['data']['customized_group']['board_pull_stream'], "白板拉流地址没有返回"
    assert_not_nil @res['data']['customized_group']['camera_pull_stream'], "摄像头拉流地址没有返回"
    assert_not_nil @res['data']['ticket'], "ticket没有返回"
  end

  # 实时直播状态
  test "customized group realtime info" do
    group = live_studio_groups(:published_group2)
    get "/api/v1/live_studio/customized_groups/#{group.id}/realtime", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal "LiveStudio::ScheduledLesson", @res['data']['live_info']['type']
  end

  # 下单
  test 'create customized group order by student' do
    group = live_studio_groups(:published_group1)
    assert_difference "Payment::Order.count", 1, "专属课下单失败" do
      post "/api/v1/live_studio/customized_groups/#{group.id}/orders", {pay_type: :weixin}, {'Remember-Token' => @student_remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
    end
  end

  test 'create customized group order by student use coupon' do
    group = live_studio_groups(:published_group1)
    coupon = payment_coupons(:coupon_one)

    assert_difference "Payment::Order.count", 1, "专属课使用优惠码下单失败" do
      post "/api/v1/live_studio/customized_groups/#{group.id}/orders", {pay_type: :weixin, coupon_code: coupon.code}, {'Remember-Token' => @student_remember_token}
      assert_response :success, "接口响应错误#{JSON.parse(response.body)}"
      res = JSON.parse(response.body)
      assert res['data'].has_key?('coupon_code')
      assert_equal 95, res['data']['amount'].to_f, "优惠价格未扣除"
    end
  end
end
