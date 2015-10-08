require 'test_helper'

class CashOperationRecordTest < ActiveSupport::TestCase


  def setup
    @teacher_account = accounts(:teacher_account)
    @operator        = users(:manager)
  end
  test 'value valid' do
    a           = build_a_record
    a.value     = 10

    assert a.valid?

  end

  test 'value not a number' do
    a           = build_a_record
    a.value     = "asdfasdfas"
    assert_not a.valid?
    a.value     = 23
    assert     a.valid?
  end


  test 'value num < 0' do
    a           = build_a_record
    a.value     = -10
    assert_not a.valid?
    a.value     = 2
    assert      a.valid?

  end

  private
  def build_a_record
    a = CashOperationRecord.new
    a.operator  = @operator
    a.account   = @teacher_account
    a
  end
end
