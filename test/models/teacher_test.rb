require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  def setup
    @old =     APP_CONSTANT["price_per_minute"]
    APP_CONSTANT["price_per_minute"] = 1
  end

  def teardown
    APP_CONSTANT["price_per_minute"] = @old
  end


  test "the find or create curriculum" do
    #teacher = users(:teacher1)
    #teacher = Teacher.find(users(:teacher1).id)
    #n = Curriculum.all.size
    #s = teacher.find_or_create_curriculums
    #
    #assert n+1 == Curriculum.all.size
  end

  test "biology teacher valid" do
    biology_teacher = Teacher.find(users(:biology_teacher1).id)
    biology_teacher.valid?
    puts biology_teacher.errors.full_messages
  end

  test "teacher keep_account" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)

    teacher_money = teacher.account.money
    student_money = student.account.money

    assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 5
    assert Reply.by_author_id(teacher.id).valid_tally_unit.size == 5
    assert Correction.by_teacher_id(teacher.id).valid_tally_unit.size == 5

    teacher.keep_account
    assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 0
    assert Reply.by_author_id(teacher.id).valid_tally_unit.size == 0
    assert Correction.by_teacher_id(teacher.id).valid_tally_unit.size == 0

    customized_course     = customized_courses(:customized_course_tally)
    assert customized_course.fees.size == 15
    customized_course.fees.each do |f|
      assert f.consumption_records.length == 1
      assert f.consumption_records.first.account_id == student.account.id
      assert f.consumption_records.first.value      == f.value
      assert f.earning_records.length == 1
      assert f.earning_records.first.account_id == teacher.account.id
      assert f.earning_records.first.value      == f.value
      assert f.video_duration   == f.feeable.video.duration
    end

    teacher.account.reload
    student.account.reload

    assert teacher.account.money == teacher_money + 15
    assert student.account.money == student_money - 15
  end
end
