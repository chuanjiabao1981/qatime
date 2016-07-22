class CustomizedTutorialCreateTest < ActionDispatch::IntegrationTest


  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_course =  customized_courses(:customized_course1)
    log_in_as(@teacher)
    sleep 100

  end

  def teardown
    # @headless.destroy
    # visit get_home_url(@teacher)
    # click_on '登出系统'
    logout_as(@teacher)
    Capybara.use_default_driver
  end

  test 'customized tutorial create' do
    visit new_customized_course_customized_tutorial_path(@customized_course)

    begin
      page.save_screenshot('screenshots/screenshot-customized-tutorial-create-0.png')

      fill_in :customized_tutorial_title,with: '这个长度不能少10的啊啊啊'
      fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'

      page.save_screenshot('screenshots/screenshot-customized-tutorial-create-1.png')

      assert_difference 'xxxx',1 do
        assert_difference 'ct_count',1 do
          page.save_screenshot('screenshots/screenshot-customized-tutorial-create-2.png')

          attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
          page.save_screenshot('screenshots/screenshot-customized-tutorial-create-3.png')
          sleep 5
          page.save_screenshot('screenshots/screenshot-customized-tutorial-create-4.png')
          click_on '新增课程'
          sleep 1
        end
      end

      page.save_screenshot('screenshots/screenshot-customized-tutorial-create-5.png')
      l = CustomizedTutorial.all.order(:created_at => :desc).first
      page.save_screenshot('screenshots/screenshot-customized-tutorial-create-6.png')
      # assert page.has_xpath?("//video[contains(@src,\"#{l.video.name}\")]"),"no video"
      #如果找不到自动抛异常
      # puts l.video.name.url
      # assert page.has_css?("source[src=\"#{l.video.name.url}\"]"),page.html
      assert page.has_css?("video")
      # page.find(:css,"video[src=\"#{l.video.name.url}\"]")



      page.save_screenshot('screenshots/screenshot-customized-tutorial-create-7.png')
    rescue Capybara::ElementNotFound =>x
      page.save_screenshot('screenshots/screenshot__xxxxxx-customized-tutorial-create.png')
    end
  end

  def xxxx
    x = Video.count
    # puts "Video count #{x}"
    # puts caller
    x
  end
  def ct_count
    x = CustomizedTutorial.count
    # puts "Customized tutorial count #{x}"
    # puts caller
    x
  end


end
