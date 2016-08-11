require 'test_helper'
class Qatime::CoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    post '/api/v1/sessions', email: @teacher.email,
                             password: 'password',
                             client_type: 'pc'
    @remember_token = JSON.parse(response.body)['data']['remember_token']
  end

  def app
    Rails.application
  end

  test "GET /api/v1/teachers/info returns teacher's info" do
    get "/api/v1/teachers/info", {}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 10, res['data'].size

    assert_equal @teacher.name, res['data']['name']
  end

  test "POST /api/v1/teachers/update updat teacher and returns teacher's info" do
    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    post "/api/v1/teachers/update", {name: "test_name", avatar: img_file, gender: "male", birthday: "1999-01-01", desc: "desc test"}, 'Remember-Token' => @remember_token

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']
    assert_equal 10, res['data'].size

    @teacher.reload
    assert_equal @teacher.name, res['data']['name']
    assert_equal @teacher.avatar_url(:small), res['data']['small_avatar_url']
    assert_equal "1999-01-01", res['data']['birthday']
    assert_equal @teacher.desc, res['data']['desc']
  end
end
