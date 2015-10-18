class CustomizedTutorialCreateTest < ActionDispatch::IntegrationTest


  self.use_transactional_fixtures = true


  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_course =  customized_courses(:customized_course1)

  end

  def teardown
    # @headless.destroy

    # visit get_home_url(@teacher)
    # click_on '登出系统'
    logout_as(@teacher)
    Capybara.use_default_driver
  end

  test 'customized tutorial create' do
    log_in_as(@teacher)
    visit new_customized_course_customized_tutorial_path(@customized_course)

    begin
      fill_in :customized_tutorial_title,with: '这个长度不能少10的啊啊啊'
      fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
      page.save_screenshot('screenshot.png')

      assert_difference 'Video.count',1 do
        assert_difference 'CustomizedTutorial.count',1 do
          attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
          sleep 10
          click_on '新增课程'
          l = CustomizedTutorial.all.order(:created_at => :desc).first
          page.save_screenshot('screenshot.png')
          assert page.has_xpath?("//video[contains(@src,\"#{l.video.name}\")]")
        end
      end
    rescue   Capybara::ElementNotFound =>x
      page.save_screenshot('screenshot__xxxxxx.png')
      raise x
    end
  end

  

  test 'customized tutorial edit' do
    log_in_as(@teacher)
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    visit edit_customized_tutorial_path(customized_tutorial1)

    video_old_name        = customized_tutorial1.video.name.url

    title_new_name        = 'fuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuck这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    assert_difference 'Video.count',0 do
      assert_difference 'CustomizedTutorial.count',0 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        sleep 10
        fill_in :customized_tutorial_title,with: title_new_name
        fill_in :customized_tutorial_content,with: content_new_name

        click_on '更新课程'
        page.save_screenshot('screenshot.png')
        assert  page.has_content? title_new_name
        assert  page.has_content? content_new_name

        customized_tutorial1.reload
        assert_not_equal customized_tutorial1.video.name.url,video_old_name
        assert page.has_xpath?("//video[contains(@src,\"#{customized_tutorial1.video.name}\")]")
      end
    end
  end

  test 'customized tutorial without video edit' do
    log_in_as(@teacher)

    title_new_name        = 'fxuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuxck这个不能少于20啊啊啊xxxx啊啊啊啊啊啊啊12345678900987654321'
    customized_tutorial1 = customized_tutorials(:customized_tutorial_without_video1)
    visit edit_customized_tutorial_path(customized_tutorial1)
    page.save_screenshot('screenshot.png')

    assert_difference 'Video.count',1 do
      assert_difference 'CustomizedTutorial.count',0 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        sleep 10
        fill_in :customized_tutorial_title,with: title_new_name
        fill_in :customized_tutorial_content,with: content_new_name

        click_on '更新课程'
        assert  page.has_content? title_new_name
        assert  page.has_content? content_new_name

        customized_tutorial1.reload
        #assert_not_equal customized_tutorial1.video.name.url,video_old_name
        assert page.has_xpath?("//video[contains(@src,\"#{customized_tutorial1.reload.video.name}\")]"),"no video url is match"

      end
    end
  end

end