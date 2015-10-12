ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'headless'



Capybara.register_driver :selenium_chrome do |app|

  Capybara::Selenium::Driver.new(app, :browser => :chrome,service_log_path:'/tmp/t.log',args:["--verbose"])
end


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def log_in_as(user)
    visit new_session_path

    fill_in :user_email,with: user.email
    fill_in :user_password,with: 'password'
    click_button '登录'
    assert page.has_content? '欢迎登录!'
  end
  def logout_as(user)
    visit get_home_url(user)
    click_on '退出系统'
  end

  def log_in2_as(user)
    open_session do |sess|
      sess.https!
      sess.post sessions_path user: { email: user.email, password: 'password'}
      sess.https!(false)
    end
  end
  def log_out2(sess)
    sess.delete signout_path
  end

  def get_home_url(user)
      case user.role
        when "teacher"
          #teachers_home_path
          solutions_teacher_path(user.id)
        when "admin"
          admins_home_path
        when "student"
          students_home_path
        when "manager"
          managers_home_path
        else
          root_path
      end
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
  end


  def teardown
    @teacher           = nil
    @student           = nil
    log_out2(@teacher_session)
    log_out2(@student_session)
    @teacher_session   = nil
    @student_session   = nil
  end
end
