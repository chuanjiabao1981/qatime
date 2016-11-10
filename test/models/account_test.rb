require 'test_helper'

class AccountTest < ActiveSupport::TestCase


  def setup
    @operator = users(:manager)
  end

  test 'withdraw_amount format not valid' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "Withdraw.count" ,0 do
      cash_operation_record = account.withdraw({value: "123as"},@operator.id)
      assert_not cash_operation_record.valid?
    end

    assert account.money == 2000
    assert_difference "Withdraw.count" ,1 do
      cash_operation_record  =        account.withdraw({value: 1234},@operator.id)
      assert       cash_operation_record.valid?,cash_operation_record.errors.full_messages
    end
    assert account.money == 766
  end

  test 'withdraw_amount greater than account money' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "Withdraw.count" ,0 do
      cash_operation_record = account.withdraw({value: 30000}, @operator.id)
      assert_not cash_operation_record.valid?
    end
    assert account.money == 2000
    assert_difference "Withdraw.count" ,1 do
      assert     account.withdraw({value: 10},@operator.id).valid?
    end
    assert account.money == 1990
  end

  test 'withdraw_amount < 0' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "Withdraw.count" ,0 do
      assert_not account.withdraw({value: -100},@operator.id).valid?
    end
    assert account.money == 2000
  end


  test 'deposit_amount format not valid' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "Deposit.count" ,0 do

      assert_not account.deposit({value: "123as"},@operator.id).valid?
    end
    assert account.money == 2000
    assert_difference "Deposit.count" ,1 do
      assert       account.deposit({value: 1234},@operator.id).valid?
    end
    assert account.money == 3234
  end

  test 'deposit_amount < 0' do
    account       = accounts(:teacher_account_2000)
    assert account.valid?
    assert_difference "Deposit.count" ,0 do
      assert_not account.deposit({value: -100},@operator.id).valid?
    end
    assert account.money == 2000

  end
end
