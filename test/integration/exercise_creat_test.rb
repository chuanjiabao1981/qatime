class ExerciseCreateTest < ActionDispatch::IntegrationTest

  set_fixture_class :homeworks => Exercise
  fixtures :homeworks

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_tutorial = customized_tutorials(:customized_tutorial1)

  end

  def teardown
    # @headless.destroy

    visit get_home_url(@teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end



  test 'exercise create with qa_files' do
    log_in_as(@teacher)
    visit new_customized_tutorial_exercise_path(@customized_tutorial)


    fill_in :exercise_title,with: '这个长度不能少10的啊啊啊'
    # fill_in :customized_tutorial_content,with: '这个不能少于20啊啊啊啊啊啊啊啊啊啊12345678900987654321'
    page.save_screenshot('screenshot.png')
      assert_difference 'Exercise.count',1 do
        assert_difference 'QaFile.count', 2 do
          # attach_file("video_name","#{Rails.root}/test/integration/test.mp4")

          #添加两个文件
          assert !page.has_xpath?("//fieldset")
          click_link '添加作业文件'
          assert page.has_xpath?("//fieldset")
          find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

          click_link '添加作业文件'
          find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/development.log")

          click_on '新增随堂练习'

          assert page.has_content?('test.jpg')
          assert page.has_content?('development.log')
        end
      end
  end


  test 'exercise edit add and remove files' do
    log_in_as(@teacher)
    exercise = homeworks(:exercise_one)
    visit edit_exercise_path(exercise)

    assert_difference 'Video.count',0 do
      assert_difference 'Exercise.count',0 do
        assert_difference 'QaFile.count',-1 do
          assert page.has_xpath?("//a[@class='remove_fields']")

          within(:xpath, "//fieldset[1]/div/div[@class='col-md-1']") do
            click_link "删除"
          end

          page.has_xpath?("//fieldset[@style='display: none;']")

          within(:xpath, "//fieldset[2]/div/div[@class='col-md-1']") do
            click_link "删除"
          end

          click_link '添加作业文件'
          find(:xpath, "//fieldset[4]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

          click_on '更新随堂练习'
          sleep 10

          assert page.has_content?('test.jpg')
          assert !page.has_content?('123_1.txt')
          assert !page.has_content?('456_1.txt')
        end
      end
    end
  end
end