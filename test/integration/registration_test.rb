require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class RegistrationTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "student registration" do
    visit root_path

    click_on "学生注册"
    student_register_code = register_codes(:student_register_code)

    fill_in :student_login_mobile, with: '13800001111'
    click_on "获取验证码", match: :first
    fill_in :student_captcha_confirmation, with: '1234'
    fill_in :student_password, with: 'pa123456'
    fill_in :student_password_confirmation, with: 'pa123456'
    find(:css, "#student_accept").set(true)
    fill_in :student_register_code_value, with: student_register_code.value

    assert_difference 'User.count', 1 do
      click_on "下一步", match: :first
    end

    fill_in :student_name, with: 'student_name_test'
    attach_file("student_avatar","#{Rails.root}/test/integration/avatar.jpg")
    select '高二', from: :student_grade

    click_on "完成注册", match: :first
    assert_equal('student_name_test', ::Student.last.name, '学生完善信息错误')
    new_logout_as(::Student.last)
  end

  test "teacher registration" do
    visit root_path

    click_on "教师注册"
    teacher_register_code = register_codes(:teacher_register_code)

    fill_in :teacher_login_mobile, with: '13811112222'
    click_on "获取验证码", match: :first
    fill_in :teacher_captcha_confirmation, with: '1234'
    fill_in :teacher_password, with: 'pa123456'
    fill_in :teacher_password_confirmation, with: 'pa123456'
    find(:css, "#teacher_accept").set(true)
    fill_in :teacher_register_code_value, with: teacher_register_code.value

    assert_difference 'User.count', 1 do
      click_on "下一步", match: :first
    end
    fill_in :teacher_name, with: 'teacher_name_test'
    attach_file("teacher_avatar","#{Rails.root}/test/integration/avatar.jpg")
    select '高中', from: :teacher_category
    select '数学', from: :teacher_subject
    select '山西', from: :teacher_province_id
    select '阳泉', from: :teacher_city_id
    fill_in :teacher_school, with: '阳泉一中'

    click_on "完成注册", match: :first
    assert_equal('teacher_name_test', ::Teacher.last.name, '学生完善信息错误')
    assert_equal '阳泉一中', ::Teacher.last.school.name
    new_logout_as(::Teacher.last)
  end
end
