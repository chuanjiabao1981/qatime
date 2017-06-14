require 'test_helper'

class CourseCreateAndEditTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher = users(:teacher1)
    log_in_as(@teacher)
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @course = course_library_courses(:course_one)
  end

  def teardown
    new_logout_as(@teacher)
    Capybara.use_default_driver
  end

  test "course create with file and video" do
    assert_difference 'Video.count', 1 do
      assert_difference '@directory.courses.count', 1 do
        visit CourseLibrary::Engine.routes.url_helpers.new_directory_course_path(@directory)
        fill_in :course_title, with: 'new course'
        fill_in :course_description, with: 'new course description'
        click_on '上传视频'
        attach_file("video_name", "#{Rails.root}/test/integration/test.mp4")
        sleep 5

        assert !page.has_xpath?("//fieldset")
        click_link '添加文件'
        assert page.has_xpath?("//fieldset")
        find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

        click_link '添加文件'
        find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/development.log")
        accept_alert
        click_on '新增大纲课程'
        page.save_screenshot('screenshots/screenshot.png')
        assert page.has_content?('test.jpg')
        assert !page.has_content?('development.log')
      end
    end
  end

  test "course update video" do
    assert_difference 'Video.count', 1 do
      visit CourseLibrary::Engine.routes.url_helpers.edit_course_path(@course)
      click_on '上传视频'
      attach_file("video_name", "#{Rails.root}/test/integration/test.mp4")
      sleep 5
      click_on '更新大纲课程'
      assert page.has_css?("video")
    end
  end

  test "course add file" do
    count = @course.qa_files.count
    visit CourseLibrary::Engine.routes.url_helpers.edit_course_path(@course)
    click_link '添加文件'
    sleep 1
    find(:xpath, "//fieldset[#{count + 1}]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")
    click_on '更新大纲课程'
    assert page.has_content?('test.jpg')
  end

  test "course remove file" do
    count = @course.qa_files.count
    @course.qa_files << qa_files(:one)
    assert_difference '@course.qa_files.count', -1 do
      visit CourseLibrary::Engine.routes.url_helpers.edit_course_path(@course)
      find(:xpath, "//fieldset[#{count}]").click_link("删除")
      click_on '更新大纲课程'
      sleep 1
    end
  end
end
