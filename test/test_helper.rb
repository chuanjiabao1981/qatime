ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'headless'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, service_log_path: '/tmp/t.log', args: ["--verbose"])
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here..
  def log_in_as(user)
    retry_count = 0
    begin
      retry_count = retry_count + 1
      visit new_session_path

      fill_in :user_login_account,with: user.email
      fill_in :user_password,with: 'password'
      click_button '登录'
    rescue Capybara::ElementNotFound => x
      page.save_screenshot('screenshots/screenshotxxxxxx.png')
      raise x if retry_count > 3
      logout_as(user)
      retry
    end
    assert page.has_content? '欢迎登录!'
  end

  def logout_as(user, confirm = false)
    visit get_home_url(user)
    if user.student?
      click_on '退出'
    else
      click_on '退出系统'
    end
  end

  def new_log_in_as(user)
    retry_count = 0
    begin
      retry_count = retry_count + 1
      visit new_session_path

      fill_in :user_login_account,with: user.email
      fill_in :user_password,with: 'password'
      click_button '登录'
    rescue Capybara::ElementNotFound => x
      page.save_screenshot('screenshots/screenshotxxxxxx.png')
      raise x if retry_count > 3
      new_logout_as(user)
      retry
    end
    # assert page.has_content? '欢迎登录!'
  end

  def new_log2_in_as(user)
    retry_count = 0
    begin
      retry_count = retry_count + 1
      visit new_session_path

      fill_in :user_login_account,with: user.login_mobile
      fill_in :user_password,with: 'password'
      click_button '登录'
    rescue Capybara::ElementNotFound => x
      page.save_screenshot('screenshots/screenshotxxxxxx.png')
      raise x if retry_count > 3
      new_logout_as(user)
      retry
    end
    assert page.has_content? '欢迎登录!'
  end

  def new_logout_as(user, confirm = false)
    visit get_home_url(user)
    find('.nav-right-user').hover if page.has_selector?('div.nav-right-user')
    click_on '退出'
  end

  def log_in2_as(user)
    open_session do |sess|
      sess.https!
      sess.post sessions_path user: { login_account: user.email, password: 'password'}
      sess.https!(false)
    end
  end
  def log_out2(sess)
    sess.delete signout_path
  end

  def api_login_by_pc(user,client_cate=nil)
    api_login(user, 'pc', client_cate)
  end

  def api_login(user, client_type, client_cate=nil)
    flag = client_cate.blank? ? true : false
    client_cate ||= user.role == 'teacher' ? 'teacher_live' : 'student_client'
    post '/api/v1/sessions', params: {
      login_account: user.login_account,
      password: 'password',
      client_type: client_type,
      client_cate: client_cate
    }
    assert_response :success
    assert_equal 1, JSON.parse(response.body)['status'], '状态码不对' if flag
    JSON.parse(response.body)['data']['remember_token']
  end

  def wap_login(user, redirect_url = nil)
    redirect_url = URI::encode(redirect_url) if redirect_url
    visit new_wap_session_path(redirect_url: redirect_url)
    fill_in :user_login_account, with: user.email
    fill_in :user_password, with: 'password'
    click_on "立即登录"
  end

  def get_home_url(user)
    case user.role
    when "teacher"
      #teachers_home_path
      solutions_teacher_path(user.id)
    when "admin"
      admins_home_path
    when "student"
      # students_home_path
      '/students/home'
    when "manager"
      managers_home_path
    else
      root_path
    end
  end

  # select2("apple", "#s2id_fruit_id")
  def select2(value, element_selector)
    select2_container = first("#{element_selector}")
    select2_container.find(".select2-choice").click

    find(:xpath, "//body").find("input.select2-input").set(value)
    page.execute_script(%|$("input.select2-input:visible").keyup();|)
    drop_container = ".select2-results"
    find(:xpath, "//body").find("#{drop_container} li", match: :first, text: value).click
  end

  def select_from_chosen(item_text,options)
    field = find_field(options[:from], visible: false)
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")

    if options[:merge]
      page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
      option_value = page.evaluate_script("value")
    end

    if options[:single_quote]
      page.execute_script("$('##{field[:id]}').val('#{option_value}')")
    else
      page.execute_script("$('##{field[:id]}').val(#{option_value})")
    end


    page.execute_script("$('##{field[:id]}').trigger('chosen:updated')")
    page.execute_script("$('##{field[:id]}').change()")

  end
  # version 2 不支持merge 但是支持修改
  # def select_from_chosen(item_text,options)
  #   field     = find_field(options[:from],visible: false)
  #   option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
  #   page.execute_script("$('##{field[:id]}').val('#{option_value}')")
  #   page.execute_script("$('##{field[:id]}').trigger('chosen:updated').trigger('change')")
  #
  # end

  ##verstion 1
  # def select_from_chosen(item_text,options)
  #   field     = find_field(options[:from],visible: false)
  #   option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
  #   page.execute_script("$('##{field[:id]}').val('#{option_value}')")
  #   page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
  #
  # end

  def random_str
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def assert_request_success?
    assert_response :success
    @res = JSON.parse(response.body)
    assert_equal 1, @res['status'], "响应错误 #{@res}"
  end

  def stub_chat_account
    account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: SecureRandom.hex(16), token: SecureRandom.hex(16) } }.to_json)
    Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
  end
end

def random_str
  (0...50).map { ('a'..'z').to_a[rand(26)] }.join
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

class LoginTestBase < ActionDispatch::IntegrationTest
  def setup
    @teacher          = Teacher.find(users(:teacher1).id)
    @teacher_session  = log_in2_as(@teacher)
    @student          = Student.find(users(:student1).id)
    @student_session  = log_in2_as(@student)
    @manager          = Manager.find(users(:manager).id)
    @manager_session  = log_in2_as(@manager)
  end


  def teardown
    @teacher           = nil
    @student           = nil
    @manager           = nil
    log_out2(@teacher_session)
    log_out2(@student_session)
    log_out2(@manager_session)
    @teacher_session   = nil
    @student_session   = nil
    @manager_session   = nil
  end
end
