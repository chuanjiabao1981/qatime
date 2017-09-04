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
    visit new_session_path
    click_on "学生注册"

    fill_in :student_login_mobile, with: '13800001111'
    click_on "获取校验码", match: :first
    fill_in :student_captcha_confirmation, with: '1234'
    fill_in :student_password, with: 'pa123456'
    fill_in :student_password_confirmation, with: 'pa123456'
    find(:css, "#student_accept").set(true)

    sleep(2)
    assert_difference 'User.count', 1 do
      click_on "提交", match: :first
    end

    fill_in :student_name, with: 'student_name_test'
    first('#student_avatar_preview2').click
    execute_script("$('#student_avatar').removeAttr('style');")
    attach_file("student_avatar","#{Rails.root}/test/integration/avatar.jpg")
    click_on '保存使用'
    first('.glyphicon').click
    find('.tecmsg-subject li', text: '高一').click
    select '山西', from: :student_province_id
    select '太原', from: :student_city_id

    click_on "立即进入", match: :first
    sleep 3
    assert_equal('student_name_test', ::Student.last.name, '学生完善信息错误')
    new_logout_as(::Student.last)
  end

  test "teacher registration" do
    visit root_path
    visit new_session_path
    click_on "教师注册"

    fill_in :teacher_login_mobile, with: '13811112222'
    click_on "获取校验码", match: :first
    fill_in :teacher_captcha_confirmation, with: '1234'
    fill_in :teacher_password, with: 'pa123456'
    fill_in :teacher_password_confirmation, with: 'pa123456'
    find(:css, "#teacher_accept").set(true)

    sleep(2)
    assert_difference 'User.count', 1 do
      click_on "提交", match: :first
    end
    fill_in :teacher_name, with: 'teacher_name_test'
    first('#teacher_avatar_preview2').click
    execute_script("$('#teacher_avatar').removeAttr('style');")
    attach_file("teacher_avatar","#{Rails.root}/test/integration/avatar.jpg")
    click_on '保存使用'
    execute_script("$('.tecmsg-grade').css('display', 'block')")
    find('.tecmsg-grade li', text: '高中').click
    execute_script("$('.tecmsg-subject').css('display', 'block')")
    find('.tecmsg-subject li', text: '数学').click
    execute_script("$('.tecmsg-year').css('display', 'block')")
    find('.tecmsg-year li', text: '20年以上').click

    select '山西', from: :teacher_province_id
    select '阳泉', from: :teacher_city_id
    fill_in :teacher_school_name, with: '阳泉一中'
    fill_in :teacher_desc, with: '测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试'

    click_on "立即进入", match: :first
    sleep 3
    assert_equal('teacher_name_test', ::Teacher.last.name, '学生完善信息错误')
    assert_equal '阳泉一中', ::Teacher.last.school.name
    new_logout_as(::Teacher.last)
  end
end
