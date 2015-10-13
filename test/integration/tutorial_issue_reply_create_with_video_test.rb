require 'test_helper'


class TutorialIssueReplyWithVideo  < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    @tutorial_issue_one               = topics(:tutorial_issue_one)

    Capybara.current_driver           =  :selenium_chrome
    @teacher1                         =  users(:teacher1)
    @tutorial_issue_reply_one         =  replies(:tutorial_issue_reply_one)
    @tutorial_issue_reply_with_video  =  replies(:tutorial_issue_reply_with_video)
    log_in_as(@teacher1)

  end

  def teardown
    logout_as(@teacher1)

    Capybara.use_default_driver
  end

  test "create with media" do
    visit tutorial_issue_path(@tutorial_issue_one)
    assert_difference 'Reply.count',1 do
     assert_difference 'TutorialIssueReply.count',1 do
       assert_difference 'Picture.where(imageable_type:"Reply").count',1 do
         assert_difference 'Picture.where(imageable_type:"TutorialIssueReply").count',0 do
           assert_difference 'Video.where(videoable_type:"Reply").count',1 do
             assert_difference 'Video.where(videoable_type:"TutorialIssueReply").count',0 do
                rely_content = '这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321'
                find('div.note-editable').set(rely_content)
                find('div.note-insert.btn-group').click
                attach_file("qa-img-file","#{Rails.root}/test/integration/test.jpg")
                click_on '上传图片'
                sleep 3

                click_on '添加视频'
                attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
                page.save_screenshot('screenshot.png')

                click_on "新增#{TutorialIssueReply.model_name.human}"

                t1  = Reply.all.order(created_at: :desc).first
                t2  = TutorialIssueReply.all.order(created_at: :desc).first
                p   = Picture.where(imageable_type: "Reply").order(created_at: :desc).first
                v   = Video.where(videoable_type: 'Reply').order(created_at: :desc).first
                assert t1.picture_ids.include?(p.id)
                assert t2.picture_ids.include?(p.id)
                assert t1.video.id == v.id
                assert t2.video.id == v.id
                assert page.has_content? rely_content

             end
           end
         end
       end
     end
    end


  end

  test 'edit add a video' do
    assert @tutorial_issue_reply_one.video.nil?
    visit edit_tutorial_issue_reply_path(@tutorial_issue_reply_one)
    page.save_screenshot('screenshot.png')
    assert_difference 'Video.where(videoable_type:"Reply").count',1 do
      assert_difference 'Video.where(videoable_type:"TutorialIssueReply").count',0 do
        click_on '添加视频'
        attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
        page.save_screenshot('screenshot.png')

        click_on "更新#{TutorialIssueReply.model_name.human}"
        v   = Video.where(videoable_type: 'Reply').order(created_at: :desc).first
        assert @tutorial_issue_reply_one.reload.video.id == v.id
      end
    end
  end

  test 'edit video'do
    assert_not @tutorial_issue_reply_with_video.video.nil?
  end
end