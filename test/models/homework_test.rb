require 'test_helper'
require 'models/shared/qa_common_state_test'

class HomeworkTest < ActiveSupport::TestCase

  include QaCommonStateTest
  self.use_transactional_fixtures = true

  test "validate" do
    homework1 = examinations(:homework1)

    assert homework1.valid?,homework1.errors.full_messages
  end

  test "create" do
    customized_course       = customized_courses(:customized_course1)
    homework                = customized_course.homeworks.build(title: "1234123",content: "1341234-------")
    homework.teacher        = customized_course.teachers.first
    homework.last_operator  = customized_course.teachers.first
    assert homework.valid?
    assert homework.customized_course.valid?

    assert_difference 'Homework.count',1 do
      assert_difference 'homework.customized_course.reload.homeworks_count',1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          #两个老师所以2
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            homework.save!
          end
        end
      end
    end
  end

  test "homework state change" do
    homework1                 = examinations(:homework1)
    check_state_change_record(homework1)
  end

  test "homework timestamp" do
    homework1                 = examinations(:homework1)
    check_state_timestamp(homework1)
  end


end
