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

    visit get_home_url(@teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test 'topic reply with video' do
    log_in_as(@teacher)
    visit topic_path(@topic)
    assert_difference 'Video.where(videoable_type:"Reply").count',1 do
      assert_difference 'Reply.count',1 do
        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

        find('div.note-editable').set('答案是这个样子的，确实是这个样子的字符0987654321009876543210')
        click_on '新增回复'
        assert page.has_content? '答案是这个样子的，确实是这个样子的字符0987654321009876543210'
      end
    end
    # fill_in :customized_tutorial_title,with: '这个长度不能少10的啊啊啊'
    # fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    page.save_screenshot('screenshot.png')

    # assert_difference 'Video.count',1 do
    #   assert_difference 'CustomizedTutorial.count',1 do
    #     attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
    #     l = CustomizedTutorial.all.order(:created_at => :desc).first
    #     click_on '新增课程'
    #     assert page.has_xpath?("//video[contains(@src,l.video.name)]")
    #   end
    # end
  end


end