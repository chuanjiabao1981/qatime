require 'test_helper'
class Qatime::CaptchaAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "GET /api/v1/app_constant get app_constant" do
    get "/api/v1/app_constant"
    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 5, res['data'].size
  end

  test "GET /api/v1/app_constant/tags get tag by categories" do
    get "/api/v1/app_constant/tags"
    assert_request_success?
    assert_equal 19, @res['data'].size, "所有标签数量不正确"
    get "/api/v1/app_constant/tags", cates: '高二'
    assert_request_success?
    names = @res['data'].map {|item| item['name'] }
    assert_includes names, "会考", "高二标签不正确"
    assert_includes names, "外教", "高二标签不正确"
    assert_not_includes names, "高考", "高二标签不正确"
    get "/api/v1/app_constant/tags", cates: '高三'
    assert_request_success?
    names = @res['data'].map {|item| item['name'] }
    assert_not_includes names, "会考", "高二标签不正确"
    assert_includes names, "外教", "高二标签不正确"
    assert_includes names, "高考", "高二标签不正确"
    get "/api/v1/app_constant/tags", cates: '高三,语文'
    assert_request_success?
    names = @res['data'].map {|item| item['name'] }
    assert_not_includes names, "会考", "高二标签不正确"
    assert_not_includes names, "外教", "高二标签不正确"
    assert_includes names, "高考", "高二标签不正确"
  end
end
