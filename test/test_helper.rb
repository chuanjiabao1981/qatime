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
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
