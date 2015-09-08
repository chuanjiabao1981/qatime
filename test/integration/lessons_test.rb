require 'test_helper'


class LessonsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @course = courses(:teacher1_course)
    @lesson  = lessons(:teacher1_lesson)


  end

  def teardown
    #@headless.destroy
    teacher = users(:teacher1)

    visit get_home_url(teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test "lesson new" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit new_teachers_course_lesson_path(@course)
    attach_file("video_name","#{Rails.root}/test/integration/test.mp4")



    find('li input.default').set("知"+"\n")

    fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊'
    fill_in :lesson_desc,with: 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
    assert_difference 'Lesson.where("tags ? :xx",{xx: "知识点讲解"}).count',1 do
      click_button '保存课程'
      sleep 10
      click_button '确定'
      page.has_content? 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
    end

  end

  test "lesson edit" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit edit_teachers_course_lesson_path(@course,@lesson)
    find('li input.default').set("常"+"\n")

    fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    page.save_screenshot('screenshot.png')

    click_button '保存课程'
    sleep 10
    assert_difference 'Lesson.where("tags ? :xx",{xx: "常见问题"}).count',1 do
      click_button '确定'
      page.has_content? 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    end

    #page.save_screenshot('screenshot.png')
  
  end


end