require 'test_helper'

module Chat
  class ChatTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)
      @teacher = users(:teacher_with_chat_account)
    end

    def teardown
      Capybara.use_default_driver
    end

    test "student say somthing" do
      Capybara.using_session("student") do
        log_in_as(@student)
      end
    end
  end
end
