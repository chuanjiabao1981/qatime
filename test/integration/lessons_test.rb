require 'test_helper'


class LessonsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @course = courses(:teacher1_course)
    @lesson  = lessons(:teacher1_lesson)
    # @video   = videos(:teacher1_lesson_video)


  end

  def teardown
    #@headless.destroy
    teacher = users(:teacher1)

    visit get_home_url(teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test "lesson new" do

    # puts 1
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit new_teachers_course_lesson_path(@course)
    assert_difference 'Video.count',1 do
      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")


      options = {from: 'lesson_tags'}
      item_text = '知识点讲解'
      select_from_chosen(item_text,options)


      # find('li input.default').set("知"+"\n")

      fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊'
      fill_in :lesson_desc,with: 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
      assert_difference 'Lesson.where("tags ? :xx",{xx: "知识点讲解"}).count',1 do

        click_button '保存课程'
        sleep 10
        click_button '确定'
        page.has_content? 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
        # puts find('video').src
        l = Lesson.all.order(:created_at => :desc).first

        # 判断video链接是否存在
        page.has_xpath?("//video[contains(@src,l.video.name)]")

      end
    end

  end

  test "lesson edit video" do




    teacher = users(:teacher1)
    log_in_as(teacher)
    visit edit_teachers_course_lesson_path(@course,@lesson)


    attach_file("video_name","#{Rails.root}/test/integration/test.mp4")


    old_name = @lesson.video.name.url


    sleep 15

    click_button '保存课程'
    sleep 10

    assert_not_equal @lesson.reload.video.name.url , old_name

    l = @lesson

    #判断video链接是否存在

    click_button '确定'
    page.has_xpath?("//video[contains(@src,l.video.name)]")


    #page.save_screenshot('screenshot.png')

  end

  test "lesson edit" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit edit_teachers_course_lesson_path(@course,@lesson)
    # find('li input.default').set("常"+"\n")

    options = {from: 'lesson_tags'}
    item_text = '常见问题'
    select_from_chosen(item_text,options)


    fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    # page.save_screenshot('screenshot.png')

    click_button '保存课程'
    sleep 10
    assert_difference 'Lesson.where("tags ? :xx",{xx: "常见问题"}).count',1 do
      click_button '确定'
      page.has_content? 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    end

    #puts Lesson.where("tags ? :xx",{xx: "常见问题"}).count
    #page.save_screenshot('screenshot.png')

  end

  test "update lesson without video" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    lesson_without_video  = lessons(:teacher1_lesson_without_video)
    visit edit_teachers_course_lesson_path(@course,lesson_without_video)
    assert_difference 'Video.count',1 do

      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
      sleep 15
      click_button '保存课程'
      page.save_screenshot('screenshot.png')
      sleep 10
      click_button '确定'
      page.has_xpath?("//video[contains(@src,lesson_without_video.reload.video.name)]")

    end

  end

end