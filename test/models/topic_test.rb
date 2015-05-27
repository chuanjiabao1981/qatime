require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  test "fixture" do
    topic = topics(:topic1)
    assert topic.valid?
  end
  test "student topic valid" do
    lesson1     = lessons(:teacher1_lesson)
    student1    = Student.find(users(:student1).id)

    topic = student1.topics.build(lesson_id:lesson1.id,title:"测试以下么哈哈哈哈哈哈哈",content:"ahahahahahahahahahahahahahahahha")
    assert topic.valid?
  end

  test "teacher topic valid" do
    lesson1     = lessons(:teacher1_lesson)
    teacher1    = Teacher.find(users(:teacher1).id)
    topic       = teacher1.topics.build(lesson_id:lesson1.id,title:"测试以下么哈哈哈哈哈哈哈",content:"ahahahahahahahahahahahahahahahha")
    assert topic.valid?
  end
end
