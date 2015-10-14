require 'test_helper'
require 'content_input_helper'


class TutorialIssueReplyWithVideo  < ActionDispatch::IntegrationTest

  include ContentInputHelper
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
               reply_content = '这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321'

               add_video_and_picture nil,reply_content
               r = TutorialIssueReply.all.order(created_at: :desc).first
               assert_picture r
               assert_video r
                # t1  = Reply.all.order(created_at: :desc).first
                # t2  = TutorialIssueReply.all.order(created_at: :desc).first
                # p   = Picture.where(imageable_type: "Reply").order(created_at: :desc).first
                # v   = Video.where(videoable_type: 'Reply').order(created_at: :desc).first
                # assert t1.picture_ids.include?(p.id)
                # assert t2.picture_ids.include?(p.id)
                # assert t1.video.id == v.id
                # assert t2.video.id == v.id
                assert page.has_content? reply_content

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
        add_video_and_picture @tutorial_issue_reply_one
        assert_picture @tutorial_issue_reply_one
        assert_video @tutorial_issue_reply_one
      end
    end
  end

  test 'edit video'do
    assert_not @tutorial_issue_reply_with_video.video.nil?

    visit edit_tutorial_issue_reply_path(@tutorial_issue_reply_with_video)
    old_url = @tutorial_issue_reply_with_video.video.name.url
    assert_difference 'Video.where(videoable_type:"Reply").count',0 do
      assert_difference 'Picture.where(imageable_type:"Reply").count',1 do
        add_video_and_picture @tutorial_issue_reply_with_video
        assert_picture @tutorial_issue_reply_with_video
        assert_video   @tutorial_issue_reply_with_video
        assert_not @tutorial_issue_reply_with_video.reload.video.name.url.nil?
        assert_not @tutorial_issue_reply_with_video.reload.video.name.url == old_url
      end
    end


  end


  def add_video_and_picture(tutorial_issue_reply,reply_content=nil)
    if tutorial_issue_reply
      action = "更新"
    else
      action = "新增"
    end
    reply_content = '这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321' if reply_content.nil?
    set_all_possible_info(reply_content)
    assert page.has_content? reply_content
    click_on "#{action}#{TutorialIssueReply.model_name.human}"
  end

  def assert_picture(tutorial_issue_reply)
    p   = Picture.where(imageable_type: 'Reply').order(created_at: :desc).first
    assert tutorial_issue_reply.picture_ids.include?(p.id),'要包含图片'
  end

  def assert_video(tutorial_issue_reply)
    v   = Video.where(videoable_type: 'Reply').order(updated_at: :desc).first
    assert tutorial_issue_reply.reload.video.id == v.id,'要有视频'
  end





end