require 'test_helper'


class TutorialIssueCreatePicture  < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    @customized_tutorial = customized_tutorials(:customized_tutorial1)
    Capybara.current_driver =  :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "create with picture" do
    student = users(:student1)
    log_in_as(student)
    visit new_customized_tutorial_tutorial_issue_path(@customized_tutorial)
    assert_difference 'Topic.count',1 do
      assert_difference 'TutorialIssue.count',1 do
        assert_difference 'Picture.where(imageable_type:"Topic").count',1 do
          assert_difference 'Picture.where(imageable_type:"TutorialIssue").count',0 do
            fill_in :tutorial_issue_title,with: '这个长度不能少10的啊啊啊aaaaa'
            find('div.note-editable').set('这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321')
            find('div.note-insert.btn-group').click
            attach_file("qa-img-file","#{Rails.root}/test/integration/test.jpg")

            click_on '上传图片'
            sleep 3
            click_on "新增#{TutorialIssue.model_name.human}"

            t1 = Topic.all.order(created_at: :desc).first
            t2 = TutorialIssue.all.order(created_at: :desc).first
            p = Picture.where(imageable_type: "Topic").order(created_at: :desc).first
            assert t1.picture_ids.include?(p.id)
            assert t2.picture_ids.include?(p.id)
            assert page.has_xpath?("//img[contains(@src,t.name)]")
          end
        end
      end
    end
    page.save_screenshot('screenshot.png')

    logout_as(student)

  end
end