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
    assert page.has_link?('个人信息'), '个人信息不存在'
    assert page.has_link?('安全设置'), '安全设置不存在'

    assert page.has_link?('编辑信息'), '编辑信息按钮不存在'
    assert page.has_content?(@teacher.name), '个人信息姓名不存在'
    assert page.has_content? @teacher.teaching_years_text
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

    find(:css, '.jcrop-preview').click
    attach_file("teacher_avatar", "#{Rails.root}/test/integration/avatar.jpg", visible: false)
    click_on '保存使用'
    sleep(1)

    fill_in :teacher_name, with: 'name test'
    fill_in :teacher_nick_name, with: 'nick_name'
    choose("男")
    execute_script("$('#teacher_birthday').val('1995-07-08')")
    select '小学', from: :teacher_category
    select '山西', from: :teacher_province_id
    select '阳泉', from: :teacher_city_id
    select '阳泉二中', from: :teacher_school_id
    select '英语', from: :teacher_subject
    select '20年以上', from: :teacher_teaching_years
    fill_in :teacher_desc, with: 'desc test'
    click_on '保存'

    assert page.has_content?('name test'), '教师name更新错误'
    assert page.has_content?('nick_name'), '教师nick_name更新错误'
    assert page.has_content?('男'), '教师gender更新错误'
    assert page.has_content?('1995-07-08'), '教师birthday更新错误'
    assert page.has_content?('小学'), '教师category更新错误'
    assert page.has_content?('英语'), '教师可授科目更新错误'
    assert page.has_content?('20年以上'), '教师执教年龄更新错误'
    assert page.has_content?('desc test'), '教师讲师简介更新错误'
  end

  test 'teacher update payment password' do
    visit info_teacher_path(@teacher)
    click_on "安全设置"
    click_on '修改支付密码'
    fill_in 'teacher_payment_password', with: '111111'
    fill_in 'teacher_payment_password_confirmation', with: '111111'
    click_on '获取验证码'
    fill_in "teacher_payment_captcha_confirmation", with: "1234"
    click_on '保存'
    sleep 2
    assert @teacher.cash_account!.authenticate('111111')
    assert page.has_content?('新密码 1时59分 后可用'), '倒计时未显示'
  end
end
