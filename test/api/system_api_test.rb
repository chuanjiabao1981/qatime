require 'test_helper'
class Qatime::SystemApiTest < ActionDispatch::IntegrationTest

  test 'check_update api' do
    get "/api/v1/system/check_update", {title: '1', version: '1', platform: 'windows'}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 9, res['data'].size
    assert res['data']['enforce']
  end
end
