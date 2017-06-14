require 'test_helper'

class Qatime::SearchAPITest < ActionDispatch::IntegrationTest
  # 搜索接口
  test 'home search teacher' do
    get "/api/v1/home/search", params: { search_cate: 'teacher', search_key: 'teacher' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal DataService::SearchManager.new('teacher').search('teacher').count, res['data'].count, '搜索结果不正确'
  end

  test 'home search course' do
    get "/api/v1/home/search", params: { search_cate: 'course', search_key: '测试' }
    assert_response :success
    res = JSON.parse(response.body)
    assert res['data'][0].key? 'product_type'
    assert res['data'][0].key? 'product'
    assert_equal DataService::SearchManager.new('course').search('测试').count, res['data'].count, '搜索结果不正确'
  end
end
