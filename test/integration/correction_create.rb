class CorrectionWithVideoTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver =  :selenium_chrome
    @teacher                =  users(:teacher1)
    @solution               =  solutions(:homework_solution_one)
  end

  def teardown
    # @headless.destroy

    visit get_home_url(@teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test 'topic reply with video' do
    log_in_as(@teacher)
    visit solution_path(@solution)
    page.save_screenshot('screenshot.png')

    assert_difference 'Video.where(videoable_type:"Correction").count',1 do
      assert_difference 'Correction.count',1 do
        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

        find('div.note-editable').set('答案是这个样子的，确实是这个样子的字符0987654321009876543210')
        page.save_screenshot('screenshot.png')

        click_on '新增作业批改'
        c = Correction.all.order(:created_at => :desc).first
        assert_not c.video.nil?
        assert page.has_content? '答案是这个样子的，确实是这个样子的字符0987654321009876543210'

      end
    end
  end


end