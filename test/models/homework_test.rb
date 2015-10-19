require 'test_helper'

class HomeworkTest < ActiveSupport::TestCase
  test "validate" do
    homework1 = examinations(:homework1)

    assert homework1.valid?
  end
end
