require 'test_helper'

class CustomizedTutorialTest < ActiveSupport::TestCase
  test "customized tutorial valid" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    assert customized_tutorial1.valid?,customized_tutorial1.errors.full_messages
    assert_not_nil customized_tutorial1.video
    assert customized_tutorial1.video.valid?,customized_tutorial1.video.errors.full_messages
    # puts customized_tutorial1.build_video.videoable_type
  end
end
