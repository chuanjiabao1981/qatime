require 'test_helper'

class HomeworkCreateAndEditTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher = users(:teacher1)
    log_in_as(@teacher)

    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @course = course_library_courses(:course_one)
    @homework = course_library_homeworks(:homework_one)

  end

  def teardown
    new_logout_as(@teacher)
    Capybara.use_default_driver
  end

  test "homework create with file" do
      assert_difference '@course.homeworks.count', 1 do
        visit CourseLibrary::Engine.routes.url_helpers.new_course_homework_path(@course)
        fill_in :homework_title, with: 'new homework'
        fill_in :homework_description, with: 'new homework description'

        assert !page.has_xpath?("//fieldset")
        click_link '添加文件'
        assert page.has_xpath?("//fieldset")
        find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

        click_link '添加文件'
        find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/development.log")
        accept_alert

        click_on '新增练习与测试'
        sleep 1
        page.save_screenshot('screenshots/screenshot.png')
        assert page.has_content?('test.jpg')
        assert !page.has_content?('development.log')
      end
  end

  test "add file" do
    count = @homework.qa_files.count
    visit CourseLibrary::Engine.routes.url_helpers.edit_homework_path(@homework)
    click_link '添加文件'
    find(:xpath, "//fieldset[#{count+1}]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")
    click_on '更新练习与测试'
    sleep 1
    assert page.has_content?('test.jpg')
  end
  test "remove file" do
    count = @homework.qa_files.count
    @homework.qa_files << qa_files(:one)
    assert_difference '@homework.qa_files.count', -1 do
      visit CourseLibrary::Engine.routes.url_helpers.edit_homework_path(@homework)
      find(:xpath, "//fieldset[#{count}]").click_link("删除")
      click_on '更新练习与测试'
      sleep 1
    end
  end
end
