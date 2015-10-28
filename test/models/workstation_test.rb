require 'test_helper'

class WorkstationTest < ActiveSupport::TestCase
  test "validation" do
      workstation1 = workstations(:workstation1)
      assert workstation1.valid?

      workstation_invalid = workstations(:workstation_invalid)
      assert !workstation_invalid.valid?
  end
end
