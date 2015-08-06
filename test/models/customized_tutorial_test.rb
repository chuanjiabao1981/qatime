require 'test_helper'

class CustomizedTutorialTest < ActiveSupport::TestCase
  test "customized tutorial valid" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    assert customized_tutorial1.valid?,customized_tutorial1.errors.full_messages
    assert_not_nil customized_tutorial1.video
    assert customized_tutorial1.video.valid?,customized_tutorial1.video.errors.full_messages
  end


  #已经存在一个video,customized tutorial create的时候和此video关联
  test "new customized tutorial with a already exsits video" do
    already_exsits_video  = videos(:teacher1_already_exsits_video)

    customized_course     = customized_courses(:customized_course1)
    customized_tutorial1  = CustomizedTutorial.new(title:"aaaabbbbcccddd",
                                                  customized_course:customized_course,
                                                  teacher: customized_course.teachers.first,
                                                  token:  already_exsits_video.token
    )
    assert customized_tutorial1.video.new_record? == false

  end

  ##没有video，通过find一定能初始化一个video
  test "customized tutorial without video" do
    tutorial_without_video = customized_tutorials(:customized_tutorial_without_video1)
    assert tutorial_without_video.video.new_record?
    assert tutorial_without_video.video.videoable_type == CustomizedTutorial.to_s
    tutorial_without_video.save
    assert tutorial_without_video.video.new_record? == false
  end
  #有video 通过find一定找到此video
  test "customized tutorial with video" do

    customized_tutorial1   = customized_tutorials(:customized_tutorial1)
    video1    = videos(:teacher1_customize_tutorial_video)


    assert customized_tutorial1.video == video1
  end

  test "customized course topic reply count" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    t                    = topics(:customized_tutorial_topic1)
    assert customized_tutorial1.valid?
    topic                =  customized_tutorial1.topics.first
    assert t.valid?, t.errors.full_messages
    r1                   = replies(:customized_tutorial_topic1_reply2)
  end

end
