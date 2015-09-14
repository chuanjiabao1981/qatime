class CustomizedTutorialCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_course =  customized_courses(:customized_course1)

  end

  def teardown
    # @headless.destroy

    visit get_home_url(@teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test 'customized tutorial create' do
    log_in_as(@teacher)
    visit new_customized_course_customized_tutorial_path(@customized_course)


    fill_in :customized_tutorial_title,with: '这个长度不能少10的啊啊啊'
    fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    page.save_screenshot('screenshot.png')

    assert_difference 'Video.count',1 do
      assert_difference 'CustomizedTutorial.count',1 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        l = CustomizedTutorial.all.order(:created_at => :desc).first
        click_on '新增课程'
        assert page.has_xpath?("//video[contains(@src,l.video.name)]")
      end
    end
  end

  test 'customized tutorial create with qa_files' do
    log_in_as(@teacher)
    visit new_customized_course_customized_tutorial_path(@customized_course)


    fill_in :customized_tutorial_title,with: '这个长度不能少10的啊啊啊'
    fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    page.save_screenshot('screenshot.png')

    assert_difference 'Video.count',1 do
      assert_difference 'CustomizedTutorial.count',1 do
        assert_difference 'QaFile.count', 2 do
          attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

          #添加两个文件
          assert !page.has_xpath?("//fieldset")
          click_link '添加文件'
          assert page.has_xpath?("//fieldset")
          find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

          click_link '添加文件'
          find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/development.log")

          click_on '新增课程'

          assert page.has_content?('test.jpg')
          assert page.has_content?('development.log')
        end
      end
    end
  end

  test 'customized tutorial edit' do
    log_in_as(@teacher)
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    visit edit_customized_tutorial_path(customized_tutorial1)

    video_old_name        = customized_tutorial1.video.name.url
    title_old_name        = customized_tutorial1.title
    content_old_name      = customized_tutorial1.content

    title_new_name        = 'fuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuck这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    assert_difference 'Video.count',0 do
      assert_difference 'CustomizedTutorial.count',0 do
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        fill_in :customized_tutorial_title,with: title_new_name
        fill_in :customized_tutorial_content,with: content_new_name

        click_on '更新课程'
        page.save_screenshot('screenshot.png')
        assert  page.has_content? title_new_name
        assert  page.has_content? content_new_name

        customized_tutorial1.reload
        assert_not_equal customized_tutorial1.video.name.url,video_old_name
        assert page.has_xpath?("//video[contains(@src,l.video.name)]")


      end
    end
  end

  test 'customized tutorial edit add and remove files' do
    log_in_as(@teacher)
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    visit edit_customized_tutorial_path(customized_tutorial1)

    video_old_name        = customized_tutorial1.video.name.url
    title_old_name        = customized_tutorial1.title
    content_old_name      = customized_tutorial1.content

    title_new_name        = 'fuck这个长度不能少10的啊啊啊'
    content_new_name      = 'fuck这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    assert_difference 'Video.count',0 do
      assert_difference 'CustomizedTutorial.count',0 do
        assert_difference 'QaFile.count',-1 do
          assert page.has_xpath?("//a[@class='remove_fields']")

          within(:xpath, "//fieldset[1]/div/div[@class='col-md-1']") do
            click_link "删除"
          end

          page.has_xpath?("//fieldset[@style='display: none;']")

          within(:xpath, "//fieldset[2]/div/div[@class='col-md-1']") do
            click_link "删除"
          end

          click_link '添加文件'
          find(:xpath, "//fieldset[4]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

          click_on '更新课程'
          sleep 10

          assert page.has_content?('test.jpg')
          assert !page.has_content?('123_1.txt')
          assert !page.has_content?('456_1.txt')
        end
      end
    end
  end
end