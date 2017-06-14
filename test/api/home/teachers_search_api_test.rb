require 'test_helper'

class Qatime::TeachersSearchAPITest < ActionDispatch::IntegrationTest
  test 'home teachers search' do
    get "/api/v1/home/teachers", params: { category_eq: '高中', subject_eq: '数学' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal DataService::SearchManager.teachers_ransack(category_eq: '高中', subject_eq: '数学').result.count, res['data'].count, '搜索结果不正确'
  end
end
