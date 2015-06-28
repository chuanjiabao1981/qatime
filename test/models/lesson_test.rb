require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  test "the truth" do
    lesson1 = lessons(:teacher1_lesson)
    lesson1.valid?
    puts lesson1.errors.full_messages
  end

  test "lesson state" do
    course  = courses(:teacher1_course)

    lesson1 = course.build_lesson

    assert lesson1.state == 'init'
  end

  test "lesson create with video" do
    course        = courses(:teacher1_course)
    lesson        = course.build_lesson
    # video         = Video.new
    # video.token   = lesson.video.token
    assert lesson.video.valid?
  end
end
