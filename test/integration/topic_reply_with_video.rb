class TopicReplyWithVideoTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver =  :selenium_chrome
    @teacher                =  users(:teacher1)
    @topic                  =  topics(:customized_course_topic1)
  end

  def teardown
    # @headless.destroy

    # visit get_home_url(@teacher)
    # click_on '登出系统'
    logout_as(@teacher)

    Capybara.use_default_driver
  end

  test 'topic reply with video' do
    log_in_as(@teacher)
    visit topic_path(@topic)
    page.save_screenshot('screenshots/screenshot.png')

    assert_difference 'Video.where(videoable_type:"Reply").count',1 do
      assert_difference 'Reply.count',1 do
        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

        find('div.note-editable').set('答案是这个样子的，确实是这个样子的字符0987654321009876543210')
        click_on '新增回复'
        r = Reply.all.order(:created_at => :desc).first
        assert page.has_xpath?("//video[contains(@src,\"#{r.video.name}\")]")
      end
    end
  end


end