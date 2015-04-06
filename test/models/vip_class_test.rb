require 'test_helper'

class VipClassTest < ActiveSupport::TestCase
  test "vipclass valid" do
     assert vip_classes(:h_math_vip_class).valid?
  end
end
