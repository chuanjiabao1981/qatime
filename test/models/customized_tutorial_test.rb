require 'test_helper'

class CustomizedTutorialTest < ActiveSupport::TestCase
  test "customized tutorial valid" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    #puts customized_tutorial1.valid?
    #puts customized_tutorial1.errors.full_messages
  end
end
