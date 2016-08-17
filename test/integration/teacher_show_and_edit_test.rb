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

  test "teacher info edit view" do
    visit info_teacher_path(@teacher)
    click_on '编辑信息', match: :first

    fill_in :teacher_name, with: 'name test'
    fill_in :teacher_nick_name, with: 'nick_name'
    choose("男")
    fill_in :teacher_birthday, with: Time.local(1995, 7, 8).strftime('%Y/%m/%d')
    select '小学', from: :teacher_category
    select '阳泉二中', from: :teacher_school_id
    select '英语', from: :teacher_subject
    select '二十年以上', from: :teacher_teaching_years
    fill_in :teacher_desc, with: 'desc test'

    click_on '保存'
    assert page.has_content?('name test'), '教师name更新错误'
    assert page.has_content?('nick_name'), '教师nick_name更新错误'
    assert page.has_content?('男'), '教师gender更新错误'
    assert page.has_content?('1995-07-08'), '教师birthday更新错误'
    assert page.has_content?('小学'), '教师category更新错误'
    assert page.has_content?('英语'), '教师可授科目更新错误'
    assert page.has_content?('二十年以上'), '教师执教年龄更新错误'
    assert page.has_content?('desc test'), '教师讲师简介更新错误'
  end

  test "teacher avatar edit view" do
    visit info_teacher_path(@teacher)
    click_on '编辑信息', match: :first
    click_on '更换头像', match: :first

    execute_script("$('input[name=\"teacher[avatar]\"]').show()")
    attach_file("teacher_avatar", "#{Rails.root}/test/integration/avatar.jpg")

    click_on '保存', match: :first
  end
end
