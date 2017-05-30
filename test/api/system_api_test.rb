require 'test_helper'
class Qatime::SystemApiTest < ActionDispatch::IntegrationTest
  test 'check_update api' do
    get "/api/v1/system/check_update", params: { category: 'teacher_live', version: '0.0.1', platform: 'windows' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 11, res['data'].size
  end

  test 'check update api enforce true' do
    get "/api/v1/system/check_update", params: { category: 'teacher_live', version: '0.0.1', platform: 'windows' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert res['data']['enforce']
  end

  test 'check update api enforce false' do
    get "/api/v1/system/check_update", params: { category: 'teacher_live', version: '0.0.2', platform: 'windows' }
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert !res['data']['enforce']
  end
end
