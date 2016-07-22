require 'test_helper'

module LiveStudio
  class Test < ActionDispatch::IntegrationTest
    def setup
      @workstation = @manager.workstations.sample
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      logout_as(@user)
      Capybara.use_default_driver
    end

    test 'manager course permission' do
      @user = users(:manager)
      log_in_as(@user)
      init_course = LiveStudio::Course.init.first
      cant_edit =  LiveStudio::Course.preview.first
      cant_delete = LiveStudio::Course.for_sell.last
      student = users(:student_with_order)
      cant_delete.taste_tickets.find_or_create_by(student: student)
      click_on '辅导班'
      # create course
      # edit init course
      # edit cant_edit
      # delete cant_edit
      # delete cant_delete
    end

    test 'seller course permission' do
      @user = users(:seller)
      # create course
      # show course
      # cant delete
      # cant edit not init course
      log_in_as(@user)
    end

    test 'waiter course permission' do
      @user = users(:waiter)
      # show course
      # cant create
      # cant edit
      # cant delete
      log_in_as(@user)
    end

    test 'teacher course permission' do
      @user = users(:teacher)
      # show course
      # edit course
      # create lesson
      # edit lesson
      # delete lesson
      # cant edit lesson
      # cant delete lesson
      log_in_as(@user)
    end
  end
end
