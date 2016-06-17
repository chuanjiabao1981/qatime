class CustomizedTutorialEditWithoutVideo < ActionDispatch::IntegrationTest

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
    logout_as(@teacher)
    Capybara.use_default_driver
  end

  test 'customized tutorial without video edit' do

    title_new_name        = 'fxuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuxck这个不能少于20啊啊啊xxxx啊啊啊啊啊啊啊12345678900987654321'
    customized_tutorial1 = customized_tutorials(:customized_tutorial_without_video1)
    visit edit_customized_tutorial_path(customized_tutorial1)
    page.save_screenshot('screenshots/screenshot.png')

    assert_difference 'Video.count',1 do
      assert_difference 'CustomizedTutorial.count',0 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        sleep 10
        fill_in :customized_tutorial_title,with: title_new_name
        fill_in :customized_tutorial_content,with: content_new_name
        sleep 10
        click_on '更新课程'
        assert  page.has_content? title_new_name
        assert  page.has_content? content_new_name

        customized_tutorial1.reload
        #assert_not_equal customized_tutorial1.video.name.url,video_old_name

      end
    end
    #如果找不到自动抛异常
    # page.find(:css,"video[src=\"#{customized_tutorial1.video.name.url}\"]")
    # assert page.has_css?("video[src=\"#{customized_tutorial1.video.name.url}\"]")
    assert page.has_css?("video")

  end
end