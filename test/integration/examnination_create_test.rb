require 'content_input_helper'

class ExaminationCreateTest < ActionDispatch::IntegrationTest


  include ContentInputHelper

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_tutorial  = customized_tutorials(:customized_tutorial1)
    @customized_course    = customized_courses(:customized_course1)

    log_in_as(@teacher)

  end

  def teardown
    logout_as(@teacher)

    Capybara.use_default_driver
  end


  test 'create with picture' do
    _create_with_picture(@customized_tutorial,Exercise)
    _create_with_picture(@customized_course,Homework)
  end

  test 'create with qa files' do
    _create_with_file(@customized_tutorial,Exercise)
    _create_with_file(@customized_course,Homework)

  end


  test 'edit with qa files' do
    exercise = examinations(:exercise_one)
    homework = examinations(:homework1)

    _edit_with_file(exercise)
    _edit_with_file(homework)
  end



  def _edit_with_file(e)
    edit_path       = send("edit_#{e.model_name.singular_route_key}_path",e)
    visit edit_path
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

      click_on "更新#{e.model_name.human}"

      sleep 10
      page.save_screenshot('screenshot.png')

      assert page.has_content?('test.jpg'),"1111"
      assert !page.has_content?('123_1.txt'),"2222"
      assert !page.has_content?('456_1.txt'),"3333"
    end
  end

  def _create_with_file(c,e)
    new_path        = send("new_#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c)
    visit new_path


    fill_in "#{e.model_name.singular_route_key}_title",with: '这个长度不能少10的啊啊啊'

    assert_difference "#{e.to_s}.count",1 do
      assert_difference "QaFile.where(qa_fileable_type: \"#{Examination.to_s}\").count", 1 do
        assert_difference "QaFile.where(qa_fileable_type: \"#{e.to_s}\").count", 0 do


          #添加两个文件
          assert !page.has_xpath?("//fieldset")
          click_link '添加作业文件'
          assert page.has_xpath?("//fieldset")
          find(:xpath, "//fieldset[1]/div/div/input").set("#{Rails.root}/test/integration/test.jpg")

          click_link '添加作业文件'
          find(:xpath, "//fieldset[2]/div/div/input").set("#{Rails.root}/test/integration/development.log")
          accept_alert

          click_on "新增#{e.model_name.human}"

          assert page.has_content?('test.jpg')
          assert !page.has_content?('development.log')
        end
      end
    end
  end
  def _create_with_picture(c,e)
    new_path        = send("new_#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c)
    visit new_path
    assert_difference "Picture.where(imageable_type: \"#{Examination.to_s}\").count",1 do
      assert_difference "Picture.where(imageable_type: \"#{e.to_s}\").count",0 do
        fill_in "#{e.model_name.singular_route_key}_title",with: '这个长度不能少10的啊啊啊aaaaa'
        set_content "asdfadfasdf"

        add_a_picture
        click_on "新增#{e.model_name.human}"

        new_examination = e.all.order(:created_at => :desc).first
        new_picture     = Picture.where(imageable_type: "#{Examination.to_s}").order(:created_at => :desc).first
        new_examination.pictures.include?(new_picture)
        page.save_screenshot('screenshot.png')
      end
    end
  end
end