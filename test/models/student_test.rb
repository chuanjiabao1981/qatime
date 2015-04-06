require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "student is valid " do
    assert users(:student1).valid?
  end
end
