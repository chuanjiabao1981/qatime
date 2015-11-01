require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class RegistrationTest < ActionDispatch::IntegrationTest

  test "student registration" do

    student_register_code = register_codes(:student_register_code)
    visit new_student_path
    fill_in :student_email,with: 'bb@qatime.cn'
    fill_in :student_name, with: 'test'
    fill_in :student_mobile, with: '15910676326'
    fill_in :student_parent_phone, with: '15910676326'
    attach_file("student_avatar","#{Rails.root}/test/integration/avatar.jpg")
    fill_in :student_password, with: '88888888'
    fill_in :student_password_confirmation, with: '88888888'
    fill_in :student_register_code_value, with: student_register_code.value

    assert_difference 'User.count',1 do
      click_on '注册'
    end
  end

  test "teacher registration" do
    teacher_register_code = register_codes(:teacher_register_code)
    visit new_teacher_path
    fill_in :teacher_email,with: 'bb@qatime.cn'
    fill_in :teacher_name, with: 'test'
    fill_in :teacher_mobile, with: '15910676326'
    fill_in :teacher_nick_name, with: "ok你好"
    select '数学',from: :teacher_subject
    select '高中',from: :teacher_category
    select '阳泉一中',from: :teacher_school_id
    attach_file("teacher_avatar","#{Rails.root}/test/integration/avatar.jpg")
    fill_in :teacher_password, with: '88888888'
    fill_in :teacher_password_confirmation, with: '88888888'
    fill_in :teacher_register_code_value, with: teacher_register_code.value
    check :teacher_accept
    assert_difference 'User.count',1 do
      click_on '注册'
    end
  end
end