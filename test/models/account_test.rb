require 'test_helper'

class AccountTest < ActiveSupport::TestCase


  test 'withdraw valid' do
    a = Account.new
    a.errors.add(:money,"12341234134")
    puts a.errors.full_messages
    assert a.valid?,a.errors.full_messages

  end
end
