require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_teachers
    t = users(:physics_teacher1)
    t.valid?
    assert users(:physics_teacher1).valid?
  end
end
