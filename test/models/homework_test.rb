require 'test_helper'

class HomeworkTest < ActiveSupport::TestCase
  test "validate" do
    homework1 = examinations(:homework1)

    assert homework1.valid?
  end

  test "create" do
    customized_course = customized_courses(:customized_course1)
    homework          = customized_course.homeworks.build(title: "1234123",content: "1341234-------")
    homework.teacher  = customized_course.teachers.first
    assert homework.valid?
    assert homework.customized_course.valid?

    assert_difference 'Homework.count',1 do
      assert_difference 'homework.customized_course.reload.homeworks_count',1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          #两个老师所以2
          assert_difference 'ActionNotification.count',2 do
            homework.save!
          end
        end
      end
    end
  end
end
