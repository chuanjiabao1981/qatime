require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test "the find or create curriculum" do
    teacher = users(:teacher1)
    teacher = Teacher.find(users(:teacher1).id)
    n = Curriculum.all.size
    s = teacher.find_or_create_curriculums

    assert n+1 == Curriculum.all.size
  end

  test "biology teacher valid" do
    biology_teacher = Teacher.find(users(:biology_teacher1).id)
    biology_teacher.valid?
    puts biology_teacher.errors.full_messages
  end
end
