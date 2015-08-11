require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  test "the truth" do
    lesson1 = lessons(:teacher1_lesson)
    assert lesson1, lesson1.errors.full_messages
  end

  test "lesson state" do
    course  = courses(:teacher1_course)

    lesson1 = course.build_lesson

    assert lesson1.state == 'init'
  end

  test "lesson new with video" do
    course        = courses(:teacher1_course)
    lesson        = course.build_lesson
    assert lesson.video.valid?,lesson.video.errors.full_messages
  end

  #已经存在一个video,lesson new的时候和此video关联
  test "lesson create with  already exsits video" do
    course                = courses(:teacher1_course)
    already_exsits_video  = videos(:teacher1_already_exsits_video)
    lesson                = course.build_lesson(token: already_exsits_video.token)
    assert lesson.video.new_record? == false
    assert lesson.video == already_exsits_video
  end

  ##没有video，通过find一定能初始化一个video
  test "lesson without video edit" do
    lesson_without_video = lessons(:teacher1_lesson_without_video)
    assert lesson_without_video.video.new_record?
    assert lesson_without_video.video.videoable_type == Lesson.to_s
    lesson_without_video.save
    assert lesson_without_video.video.new_record? == false
  end
  #有video 通过find一定找到此video
  test "lesson with video edit" do

    lesson1   = lessons(:teacher1_lesson)
    video1    = videos(:teacher1_lesson_video)


    assert lesson1.video == video1

    # puts lesson1.video.to_json
    # puts video1.to_json
  end
end
