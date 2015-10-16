require 'content_input_helper'

module ReplyTestHelper
  include ContentInputHelper

  def edit_change_video(t)
    assert_not t.video.nil?

    old_url = t.video.name.url

    assert_difference 'Video.where(videoable_type:"Reply").count',0 do
      assert_difference 'Picture.where(imageable_type:"Reply").count',1 do
        add_video_and_picture t
        assert_picture t
        assert_video   t
        assert_not t.reload.video.name.url.nil?
        assert_not t.reload.video.name.url == old_url
      end
    end
  end

  def edit_add_video(t)
    assert_difference 'Video.where(videoable_type:"Reply").count',1 do
      assert_difference "Video.where(videoable_type:\"#{t.model_name}\").count",0 do
        add_video_and_picture t
        assert_picture t
        assert_video t
      end
    end
  end
  def reply_create_with_media(t)
    assert_difference 'Reply.count',1 do
      assert_difference "#{t}.count",1 do
        assert_difference 'Picture.where(imageable_type:"Reply").count',1 do
          assert_difference "Picture.where(imageable_type:\"#{t}\").count",0 do
            assert_difference 'Video.where(videoable_type:"Reply").count',1 do
              assert_difference "Video.where(videoable_type:\"#{t}\").count",0 do
                content = '这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321'
                add_video_and_picture t.constantize.new,content
                r = t.constantize.all.order(created_at: :desc).first
                assert_picture r
                assert_video r
                assert page.has_content? content
              end
            end
          end
        end
      end
    end
  end
end