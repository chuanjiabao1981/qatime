require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "student is valid " do
    student1 = users(:student1)
    assert users(:student1).valid?
  end
end
