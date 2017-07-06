require 'test_helper'


class TopicCreateWithPicture  < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "topic create with picture" do
    student = users(:student1)
    lesson = lessons(:teacher1_lesson)
    log_in_as(student)
    visit new_lesson_topic_path(lesson)
    assert_difference 'Topic.count',1 do
      assert_difference 'Picture.where(imageable_type:"Topic").count',1 do

        fill_in :topic_title,with: '这个长度不能少10的啊啊啊aaaaa'
        find('div.note-editable').set('这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321')
        find('div.note-insert.btn-group').click
        attach_file("qa-img-file","#{Rails.root}/test/integration/test.jpg")

        click_on '上传图片'
        sleep 3
        click_on '新增讨论'

        t = Topic.all.order(created_at: :desc).first
        p = Picture.where(imageable_type: "Topic").order(created_at: :desc).first
        assert t.picture_ids.include?(p.id)
        assert page.has_xpath?("//img[contains(@src,t.name)]")
      end
    end
    page.save_screenshot('screenshots/screenshot.png')

    new_logout_as(student)
  end
end
