require 'test_helper'

class AccountTest < ActiveSupport::TestCase


  def setup
    @operator = users(:manager)
  end

  test 'withdraw_amount format not valid' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "CashOperationRecord.withdraw.count" ,0 do
      assert_not account.withdraw({withdraw_amount: "123as"},@operator.id)
      assert_not account.valid?
    end

    assert account.money == 2000
    assert_difference "CashOperationRecord.withdraw.count" ,1 do
      assert       account.withdraw({withdraw_amount: "1234"},@operator.id)
      assert       account.valid?,account.errors.full_messages
    end
    assert account.money == 766
  end

  test 'withdraw_amount greater than account money' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "CashOperationRecord.withdraw.count" ,0 do
      assert_not account.withdraw({withdraw_amount: "30000"},@operator.id)
    end
    assert_not account.valid?
    assert account.money == 2000
    assert_difference "CashOperationRecord.withdraw.count" ,1 do
      assert     account.withdraw({withdraw_amount: "10"},@operator.id)
    end
    assert     account.valid?,account.errors.full_messages
    assert account.money == 1990
  end

  test 'withdraw_amount < 0' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "CashOperationRecord.withdraw.count" ,0 do
      assert_not account.withdraw({withdraw_amount: "-100"},@operator.id)
    end
    assert_not account.valid?
    assert account.money == 2000
  end


  test 'deposit_amount format not valid' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "CashOperationRecord.deposit.count" ,0 do

      assert_not account.deposit({deposit_amount: "123as"},@operator.id)
    end
    assert_not account.valid?
    assert account.money == 2000
    assert_difference "CashOperationRecord.deposit.count" ,1 do
      assert       account.deposit({deposit_amount: "1234"},@operator.id)
    end
    assert       account.valid?,account.errors.full_messages
    assert account.money == 3234
  end

  test 'deposit_amount < 0' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "CashOperationRecord.deposit.count" ,0 do
      assert_not account.deposit({deposit_amount: "-100"},@operator.id)
    end
    assert_not account.valid?
    assert account.money == 2000

  end
end
