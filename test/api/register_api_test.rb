require 'test_helper'
class Qatime::RegisterAPITest < ActionDispatch::IntegrationTest
  def app
    Rails.application
  end

  test "POST /api/v1/user/register register teacher" do
    teacher_register_code = register_codes(:teacher_register_code)

    post "/api/v1/captcha", {send_to: "13892920101", key: :register_captcha}
    post "/api/v1/user/register", {login_mobile: "13892920101", captcha_confirmation: "1234", password: "pa123456", password_confirmation: "pa123456", register_code_value: teacher_register_code.value, accept: "1", type: "teacher", client_type: "app"}

    assert_response :success
    res = JSON.parse(response.body)

    assert_equal 1, res['status']

    teacher = ::Teacher.find_by(login_mobile: res['data']['user']['login_mobile'])
    remember_token = res['data']['remember_token']

    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/teachers/#{teacher.id}/profile", {name: "test_name", avatar: img_file, gender: "male", category: "小学", subject: "数学", birthday: "1999-01-01", desc: "desc test", email: "123@456.com", email_confirmation: "123@456.com"}, 'Remember-Token' => remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 17, res['data'].size

    teacher.reload
    assert_equal teacher.name, res['data']['name']
    assert_equal teacher.avatar_url, res['data']['avatar_url']
    assert_equal teacher.category, res['data']['category']
    assert_equal teacher.subject, res['data']['subject']
    assert_equal "1999-01-01", res['data']['birthday']
    assert_equal teacher.desc, res['data']['desc']
  end

  test "POST /api/v1/user/register register student" do
    student_register_code = register_codes(:student_register_code)

    post "/api/v1/captcha", {send_to: "13892920103", key: :register_captcha}
    post "/api/v1/user/register", {login_mobile: "13892920103", captcha_confirmation: "1234", password: "pa123456", password_confirmation: "pa123456", register_code_value: student_register_code.value, accept: "1", type: "student", client_type: "app"}

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']

    student = ::Student.find_by(login_mobile: res['data']['user']['login_mobile'])
    remember_token = res['data']['remember_token']

    img_file = fixture_file_upload("#{Rails.root}/test/integration/avatar.jpg", 'image/jpeg')
    put "/api/v1/students/#{student.id}/profile", {name: "test_name", avatar: img_file, gender: "male", grade: "高一", birthday: "1999-01-01", desc: "desc test", email: "123@456.com", email_confirmation: "123@456.com", parent_phone: "13892920104", parent_phone_confirmation: "13892920104"}, 'Remember-Token' => remember_token

    assert_response :success
    res = JSON.parse(response.body)
    assert_equal 1, res['status']
    assert_equal 14, res['data'].size

    student.reload
    assert_equal student.name, res['data']['name']
    assert_equal student.avatar_url, res['data']['avatar_url']
    assert_equal student.grade, res['data']['grade']
    assert_equal "1999-01-01", res['data']['birthday']
    assert_equal student.desc, res['data']['desc']
  end
end
