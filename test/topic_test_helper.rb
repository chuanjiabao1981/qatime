require 'content_input_helper'

module TopicTestHelper
  include ContentInputHelper

  def topic_create_with_picture(t)
    assert_difference 'Topic.count',1 do
      assert_difference "#{t}.count",1 do
        assert_difference 'Picture.where(imageable_type:"Topic").count',1 do
          assert_difference "Picture.where(imageable_type:\"#{t}\").count",0 do
            fill_in "#{t.constantize.model_name.singular}_title",with: '这个长度不能少10的啊啊啊aaaaa'
            set_content('这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321')
            add_a_picture
            click_on "新增#{t.constantize.model_name.human}"
            t1 = Topic.all.order(created_at: :desc).first
            t2 = t.constantize.all.order(created_at: :desc).first
            assert_picture t1
            assert_picture t2
          end
        end
      end
    end
  end
end