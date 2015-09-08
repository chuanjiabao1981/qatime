require 'test_helper'

class AdminTest < ActiveSupport::TestCase


  test "admin valid" do
    admin = Admin.find(users(:admin).id)
    assert admin.valid?, admin.errors.full_messages
  end
end
