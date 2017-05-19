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
    assert page.has_link?('个人信息'), '个人信息不存在'
    assert page.has_link?('安全设置'), '安全设置不存在'

    assert page.has_link?('编辑信息'), '编辑信息按钮不存在'
    assert page.has_content?(@student.name), '个人信息姓名不存在'
  end

  test "student safe view" do
    visit info_student_path(@student)
    click_on '安全设置'

    assert page.has_content?('修改登录密码'), '修改登录密码按钮不存在'
    assert page.has_content?('修改绑定手机'), '修改绑定手机按钮不存在'
    assert page.has_content?('修改绑定邮箱'), '修改绑定邮箱按钮不存在'
    assert page.has_content?('修改家长手机'), '修改家长手机按钮不存在'
  end

  test "student info edit view" do
    visit info_student_path(@student)
    click_on '编辑信息', match: :first

    find(:css, '.jcrop-preview').click
    attach_file("student_avatar", "#{Rails.root}/test/integration/avatar.jpg", visible: false)
    click_on '保存使用'
    sleep(1)

    fill_in :student_name, with: 'name test'
    choose("男")
    execute_script("$('#student_birthday').val('1995-07-08')")
    select '高二', from: :student_grade
    select '山西', from: :student_province_id
    select '阳泉', from: :student_city_id
    select '阳泉二中', from: :student_school_id
    fill_in :student_desc, with: 'desc test'

    click_on '保存'
    @student.reload
    assert_equal('name test', @student.name, '学生name更新错误')
    assert_equal('男', @student.gender_text, '学生gender更新错误')
    assert page.has_content?('1995-07-08'), '学生birthday更新错误'
    assert_equal('高二', @student.grade, '学生grade更新错误')
    assert page.has_content?('desc test')
  end

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
    sleep 2
    assert_equal("13811110000", @student.parent_phone, '更新家长手机错误')
  end

  test 'student update payment password' do
    visit info_student_path(@student)
    click_on "安全设置"
    click_on '修改支付密码'
    fill_in 'student_payment_password', with: '111111'
    fill_in 'student_payment_password_confirmation', with: '111111'
    click_on '获取验证码'
    fill_in "student_payment_captcha_confirmation", with: "1234"
    click_on '保存'
    sleep 2
    assert @student.cash_account!.authenticate('111111')
    assert page.has_content?('新密码 1时59分 后可用'), '倒计时未显示'
  end
end
