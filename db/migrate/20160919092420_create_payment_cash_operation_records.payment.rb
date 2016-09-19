# This migration comes from payment (originally 20160919091545)
class CreatePaymentCashOperationRecords < ActiveRecord::Migration
  def change
    create_table :payment_cash_operation_records do |t|
      t.integer :operator_id
      t.integer :account_id
      t.float :value
      t.string :type
      t.integer :status, default: 0
      t.timestamps null: false
    end

    Withdraw.find_each(:batch_size => 1000) do |w|
      values = %w(operator_id account_id value type created_at updated_at).map{|col| [Fixnum,Float].include?(w.send(col).class) ?
        w.send(col) : "'#{w.send(col).to_s[0,19]}'"}
      sql = "insert into payment_cash_operation_records (operator_id,account_id,value,type,created_at,updated_at) values (#{values.join(",")})"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
