require 'test_helper'
class Qatime::RegisterAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "POST /api/v1/user/register register student" do
    # 获取注册码
    get "/api/v1/user/register_code_valid", {type: "Student"}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应不正确 #{res['data']}"
    student_register_code = res['data']

    # 发送手机验证码
    post "/api/v1/captcha", {send_to: "13892920103", key: :register_captcha}
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应不正确 #{res}"

    # 提交注册表单
    post "/api/v1/user/register", {login_mobile: "13892920103", captcha_confirmation: "1234", password: "pa123456", password_confirmation: "pa123456", register_code_value: student_register_code, accept: "1", type: "Student", client_type: "app"}

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应不正确 #{res['data']}"

    student = ::Student.find_by(login_mobile: res['data']['user']['login_mobile'])
    remember_token = res['data']['remember_token']

    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')

    # 完善个人信息
    put "/api/v1/students/#{student.id}/profile", {name: "test_name", avatar: img_file, gender: "male", grade: "高一", birthday: "1999-01-01", desc: "desc test", email: "123@456.com", email_confirmation: "123@456.com", parent_phone: "13892920104", parent_phone_confirmation: "13892920104"}, 'Remember-Token' => remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status'], "响应不正确 #{res['data']}"
    assert_equal 16, res['data'].size, "响应数据不正确"

    student.reload
    assert_equal student.name, res['data']['name']
    assert_equal student.avatar_url, res['data']['avatar_url']
    assert_equal student.grade, res['data']['grade']
    assert_equal "1999-01-01", res['data']['birthday']
    assert_equal student.desc, res['data']['desc']
    assert_equal student.email, res['data']['email']
    assert_equal '13892920104', student.parent_phone
  end
end
