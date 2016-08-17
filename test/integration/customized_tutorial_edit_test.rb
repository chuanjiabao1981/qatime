class CustomizedTutorialEditTest < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_course =  customized_courses(:customized_course1)
    log_in_as(@teacher)

  end

  def teardown
    # @headless.destroy
    # visit get_home_url(@teacher)
    # click_on '登出系统'
    new_logout_as(@teacher)
    Capybara.use_default_driver
  end

  test 'customized tutorial edit' do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    visit edit_customized_tutorial_path(customized_tutorial1)

    video_old_name        = customized_tutorial1.video.name.url

    title_new_name        = 'fuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuck这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    assert_difference 'Video.count',0 do
      assert_difference 'CustomizedTutorial.count',0 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        sleep 5
        fill_in :customized_tutorial_title,with: title_new_name
        fill_in :customized_tutorial_content,with: content_new_name
        sleep 5

        click_on '更新课程'
        page.save_screenshot('screenshots/screenshot.png')
        assert  page.has_content? title_new_name
        assert  page.has_content? content_new_name


      end
    end

    customized_tutorial1.reload
    assert_not_equal customized_tutorial1.video.name.url,video_old_name
    #如果找不到自动抛异常
    # page.find(:css,"video[src=\"#{customized_tutorial1.video.name.url}\"]")
    # assert page.has_css?("video[src=\"#{customized_tutorial1.video.name.url}\"]")

    assert page.has_css?("video")


  end

end
