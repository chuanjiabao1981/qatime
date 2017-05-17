require 'test_helper'

module CourseLibrary
  class SyllabusFlowsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @syllabus = course_library_syllabuses(:syllabuses_one)
      @directory = course_library_directories(:directory_one)
      @teacher = users(:teacher1)
      log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "syllabuses index" do
      visit course_library.teacher_syllabuses_path(@teacher)
      assert page.has_content? '备课中心'
      assert page.has_link? '新增教学大纲'
      syllabus = @teacher.syllabuses.first
      assert page.all('ul.manage-list li').size, @teacher.syllabuses.count
      assert page.has_content? syllabus.description
      assert page.has_link?(syllabus.title, href: course_library.syllabus_directory_path(@syllabus,@directory)), '链接不存在'
    end

    test "syllabuses new and create" do
      visit course_library.teacher_syllabuses_path(@teacher)
      click_on '新增教学大纲'
      fill_in :syllabus_title, with: 'new syllabus'
      fill_in :syllabus_description, with: 'description for new syllabus'
      assert_difference '@teacher.syllabuses.count', 1 do
        click_on '保存'
        assert page.has_link?('new syllabus')
      end
    end

    test "syllabus edit and update" do
      visit course_library.edit_teacher_syllabus_path(@teacher,@syllabus)
      fill_in :syllabus_title, with: 'new syllabus title'
      click_on '保存'
      assert_equal 'new syllabus title', @syllabus.reload.title
    end

  end
end


