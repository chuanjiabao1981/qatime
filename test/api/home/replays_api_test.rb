require 'test_helper'

class Qatime::ReplaysAPITest < ActionDispatch::IntegrationTest
  # 搜索接口
  test 'home search replays' do
    get "/api/v1/home/replays", s: 'updated_at desc'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal DataService::SearchManager.replays_ransack(s: 'updated_at desc').result.count, res['data'].count, '搜索结果不正确'
  end

  test 'home search replay lesson' do
    item = ::Recommend::ReplayItem.default.items.first
    get "/api/v1/home/replays/#{item.id}/replay"
    assert_response :success
    res = JSON.parse(response.body)
    assert res['data'].key?('video_url'), '视频链接不存在'
    assert_equal res['data']['replay_times'].to_i, item.reload.replay_times, '回放数未记录'
  end
end
