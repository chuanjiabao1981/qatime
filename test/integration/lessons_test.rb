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
    click_on '退出'
    Capybara.use_default_driver
  end

  test "lesson new" do

    # puts 1
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit new_teachers_course_lesson_path(@course)
    assert_difference 'Video.count',1 do
      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")


      options = {from: 'lesson_tags',single_quote: true}
      item_text = '知识点讲解'
      select_from_chosen(item_text,options)


      # find('li input.default').set("知"+"\n")

      fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊'
      fill_in :lesson_desc,with: 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
      assert_difference 'Lesson.where("tags ? :xx",{xx: "知识点讲解"}).count',1 do

        click_button '保存课程'
        sleep 5
        click_button '确定'
        page.has_content? 'lesson_desc 这个长度不能小于多少啊啊啊啊，lesson_desc 这个长度到底是多少'
        # puts find('video').src
        l = Lesson.all.order(:created_at => :desc).first

        # 判断video链接是否存在
        page.has_xpath?("//video[contains(@src,\"#{l.video.name}\")]")

      end
    end

  end

  test "lesson new with single qa_file" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit new_teachers_course_lesson_path(@course)

    # 一次上传一个文件
    assert_difference 'QaFile.count',1 do
      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
      options = {from: 'lesson_tags',single_quote: true}
      item_text = '知识点讲解'
      select_from_chosen(item_text,options)

      fill_in :lesson_name,with: 'lesson_name 测试一下文件上传'
      fill_in :lesson_desc,with: 'lesson_desc 测试一下文件上传，测试一下文件上传，lesson_desc 测试一下文件上传'


      !page.has_xpath?("//fieldset")
      click_link '添加文件'
      page.has_xpath?("//fieldset")

      find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")
      click_button '保存课程'
      sleep 5
      click_button '确定'

      # 判断上传的链接是否出现在展示列表里

      page.has_content? 'test.jpg'
    end

  end


  # 测试一次上传多个文件，测试一下过滤
  test "lesson new with multi qa_files" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit new_teachers_course_lesson_path(@course)
    # 一次上传多个文件,其中有一个只是点击了添加链接，没有赋值
    assert_difference 'QaFile.count',2 do
      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
      options = {from: 'lesson_tags',single_quote: true}
      item_text = '知识点讲解'
      select_from_chosen(item_text,options)

      fill_in :lesson_name,with: 'lesson_name 测试一下文件上传'
      fill_in :lesson_desc,with: 'lesson_desc 测试一下文件上传，测试一下文件上传，lesson_desc 测试一下文件上传'

      click_link '添加文件'
      find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/development.log")
      # Change is here:
      accept_alert
      click_link '添加文件'
      find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")
      click_link '添加文件'
      find(:xpath, "//fieldset[3]/div/div/input").set("#{Rails.root}/test/integration/avatar.jpg")
      click_link '添加文件'
      find(:xpath, "//fieldset[4]/div/div/input").set("#{Rails.root}/test/integration/test1.mp4")
      accept_alert

      click_button '保存课程'
      sleep 5
      click_button '确定'

      # 判断上传的链接是否出现在展示列表里

      assert !page.has_content?('development.log')
      assert page.has_content?('avatar.jpg')
      assert page.has_content?('test.jpg')
      assert !page.has_content?('test1.mp4')

    end

  end

  # 测试lesson的show页面，看看是否有文件列表

  test "lesson show with qa_files" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    lesson_with_qa_files  = lessons(:teacher1_lesson)

    visit course_path(@course,lesson_id:lesson_with_qa_files.id)

    assert page.has_content? '123.txt'
    assert page.has_content? '456.txt'
    assert page.has_content? '789.txt'


    visit lesson_path(lesson_with_qa_files)

    assert page.has_content? '123.txt'
    assert page.has_content? '456.txt'
    assert page.has_content? '789.txt'

  end

  # 测试修改lesson，删除文件和添加文件
  test "update lesson add and remove qa_files" do
    teacher = users(:teacher1)
    log_in_as(teacher)

    visit edit_teachers_course_lesson_path(@course,@lesson)

    assert page.has_xpath?("//a[@class='remove_fields']")

    #删除第一个123.txt这个文件

    assert_difference 'QaFile.count',-1 do
      within(:xpath, "//fieldset[1]/div/div[@class='col-md-1']") do
        click_link "删除"
      end

      page.has_xpath?("//fieldset[@style='display: none;']")

      within(:xpath, "//fieldset[2]/div/div[@class='col-md-1']") do
        click_link "删除"
      end

      click_link '添加文件'
      find(:xpath, "//fieldset[4]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

      click_button '保存课程'
      sleep 5
      click_button '确定'

      # 判断上传的链接是否出现在展示列表里

      assert page.has_content?('test.jpg')
      assert !page.has_content?('123.txt')
      assert !page.has_content?('456.txt')

    end

  end

  test "lesson edit video" do




    teacher = users(:teacher1)
    log_in_as(teacher)
    visit edit_teachers_course_lesson_path(@course,@lesson)


    attach_file("video_name","#{Rails.root}/test/integration/test.mp4")


    old_name = @lesson.video.name.url


    sleep 5

    click_on '保存课程'
    sleep 5

    assert_not_equal @lesson.reload.video.name.url , old_name

    l = @lesson

    #判断video链接是否存在

    click_on '确定'
    page.has_xpath?("//video[contains(@src,\"#{l.video.name}\")]")


    #page.save_screenshot('screenshots/screenshot.png')

  end

  test "lesson edit" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    visit edit_teachers_course_lesson_path(@course,@lesson)
    # find('li input.default').set("常"+"\n")

    options = {from: 'lesson_tags',single_quote: true}
    item_text = '常见问题'
    select_from_chosen(item_text,options)


    fill_in :lesson_name,with: 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    # page.save_screenshot('screenshots/screenshot.png')

    click_button '保存课程'
    sleep 5
    assert_difference 'Lesson.where("tags ? :xx",{xx: "常见问题"}).count',1 do
      click_button '确定'
      page.has_content? 'lesson_name 这个长度不能少10的啊啊啊aaaaaaaaaaaaaaa'
    end

    #puts Lesson.where("tags ? :xx",{xx: "常见问题"}).count
    #page.save_screenshot('screenshots/screenshot.png')

  end

  test "update lesson without video" do
    teacher = users(:teacher1)
    log_in_as(teacher)
    lesson_without_video  = lessons(:teacher1_lesson_without_video)
    visit edit_teachers_course_lesson_path(@course,lesson_without_video)
    assert_difference 'Video.count',1 do

      attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
      sleep 5
      click_button '保存课程'
      page.save_screenshot('screenshots/screenshot.png')
      sleep 5
      click_button '确定'
      page.has_xpath?("//video[contains(@src,lesson_without_video.reload.video.name)]")

    end

  end

end
