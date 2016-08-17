require 'test_helper'

class StudentInfoShowAndEditTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @student = users(:student1)
    log_in_as(@student)
  end

  def teardown
    new_logout_as(@student)
    Capybara.use_default_driver
  end

  test "student info view" do
    visit info_student_path(@student)
    assert page.has_content?('个人信息'), '个人信息不存在'
    assert page.has_content?('安全设置'), '安全设置不存在'

    assert page.has_content?('编辑信息'), '编辑信息按钮不存在'
    assert page.has_content?(@student.name), '个人信息姓名不存在'
  end

  # test "student safe view" do
  #   visit info_student_path(@student)
  #   click_on '安全设置'

  #   assert page.has_content?('修改登录密码'), '修改登录密码按钮不存在'
  #   assert page.has_content?('修改绑定手机'), '修改绑定手机按钮不存在'
  #   assert page.has_content?('修改绑定邮箱'), '修改绑定邮箱按钮不存在'
  #   assert page.has_content?('修改家长手机'), '修改家长手机按钮不存在'
  # end

  # test "student info edit view" do
  #   visit info_student_path(@student)
  #   click_on '编辑信息', match: :first

  #   fill_in :student_name, with: 'name test'
  #   choose("男")
  #   fill_in :student_birthday, with: Time.local(1995, 7, 8).strftime('%Y/%m/%d')
  #   select '高二', from: :student_grade
  #   fill_in :student_desc, with: 'desc test'

  #   click_on '保存'
  #   @student.reload
  #   assert_equal('name test', @student.name, '学生name更新错误')
  #   assert_equal('男', @student.gender_text, '学生gender更新错误')
  #   assert page.has_content?('1995-07-08'), '学生birthday更新错误'
  #   assert_equal('高二', @student.grade, '学生grade更新错误')
  #   assert_equal('desc test', @student.desc, '学生desc更新错误')
  # end

  # test "student avatar edit view" do
  #   visit info_student_path(@student)
  #   click_on '编辑信息', match: :first
  #   click_on '更换头像', match: :first

  #   execute_script("$('input[name=\"student[avatar]\"]').show()")
  #   attach_file("student_avatar", "#{Rails.root}/test/integration/avatar.jpg")

  #   click_on '保存', match: :first
  # end

  test "student update parent phone" do
    visit info_student_path(@student)
    click_on "安全设置"
    click_on "修改家长手机", match: :first

    fill_in "student_current_password", with: "password"
    fill_in "student_parent_phone", with: "13811110000"
    click_on "获取验证码"
    fill_in "student_captcha_confirmation", with: "1234"
    click_on "绑定家长手机"

    @student.reload
    assert_equal("13811110000", @student.parent_phone, '更新家长手机错误')
  end
end
