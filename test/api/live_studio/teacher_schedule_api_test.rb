require 'test_helper'

class Qatime::TeacherScheduleAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  test 'GET /api/v1/live_studio/teachers/:id/schedule_data' do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/schedule_data", {date_type: 'month', date: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    assert_response :success
    data = JSON.parse(response.body)['data']
    assert data.class == Array
    assert_equal 2, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_month.to_date && return_date <= Time.now.end_of_month.to_date, '返回数据日期不正确'

    get "/api/v1/live_studio/teachers/#{@teacher.id}/schedule_data", {date_type: 'week', date: Time.now.to_date.to_s}, 'Remember-Token' => @remember_token
    assert_response :success
    data = JSON.parse(response.body)['data']
    assert data.class == Array
    assert_equal 29, data.first['lessons'].count, '返回课程数量不对'
    return_date = data.first['date'].to_date
    assert return_date >= Time.now.beginning_of_week.to_date && return_date <= Time.now.end_of_week.to_date, '返回数据日期不正确'
  end
end
