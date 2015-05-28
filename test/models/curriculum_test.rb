require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  test "the truth" do
    curriculum1 = curriculums(:teacher1_math_curriculum)
    assert curriculum1.valid?
    #puts curriculum1.teaching_program
  end
end
