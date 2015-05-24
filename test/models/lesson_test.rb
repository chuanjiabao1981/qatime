require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  test "the truth" do
    lesson1 = lessons(:teacher1_lesson)
    lesson1.valid?
    puts lesson1.errors.full_messages
  end
end
