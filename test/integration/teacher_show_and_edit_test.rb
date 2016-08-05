require 'test_helper'

class TeacherInfoShowAndEditTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @teacher = users(:physics_teacher1)
    log_in_as(@teacher)
  end

  def teardown
    new_logout_as(@teacher)
    Capybara.use_default_driver
  end

  test "teacher info view" do
    visit info_teacher_path(@teacher)
    assert page.has_content?('个人信息'), '个人信息不存在'
    assert page.has_content?('安全设置'), '安全设置不存在'

    assert page.has_content?('编辑信息'), '编辑信息按钮不存在'
    assert page.has_content?(@teacher.name), '个人信息姓名不存在'
  end

  test "teacher safe view" do
    visit info_teacher_path(@teacher)
    click_on '安全设置'

    assert page.has_content?('修改登录密码'), '修改登录密码按钮不存在'
    assert page.has_content?('修改绑定手机'), '修改绑定手机按钮不存在'
    assert page.has_content?('修改绑定邮箱'), '修改绑定邮箱按钮不存在'
  end

  # test "teacher info edit view" do
  #   visit info_teacher_path(@teacher)
  #   click_on '编辑信息', match: :first

  #   fill_in :teacher_name, with: 'name test'
  #   choose("男")
  #   fill_in :teacher_birthday, with: Time.local(1995, 7, 8).strftime('%Y/%m/%d')
  #   select '高二', from: :teacher_grade
  #   select '山西', from: :teacher_province_id
  #   select '大同', from: :teacher_city_id
  #   fill_in :teacher_desc, with: 'desc test'

  #   click_on '保存'
  #   @teacher.reload
  #   assert_equal('name test', @teacher.name, '学生name更新错误')
  #   assert_equal('男', @teacher.gender_text, '学生gender更新错误')
  #   assert page.has_content?('1995-07-08'), '学生birthday更新错误'
  #   assert_equal('高二', @teacher.grade, '学生grade更新错误')
  #   assert_equal('山西', @teacher.province.name, '学生province更新错误')
  #   assert_equal('大同', @teacher.city.name, '学生city更新错误')
  #   assert_equal('desc test', @teacher.desc, '学生desc更新错误')
  # end

  # test "teacher avatar edit view" do
  #   visit info_teacher_path(@teacher)
  #   click_on '编辑信息', match: :first
  #   click_on '更换头像', match: :first

  #   execute_script("$('input[name=\"teacher[avatar]\"]').show()")
  #   attach_file("teacher_avatar", "#{Rails.root}/test/integration/avatar.jpg")

  #   click_on '保存', match: :first
  # end
end
