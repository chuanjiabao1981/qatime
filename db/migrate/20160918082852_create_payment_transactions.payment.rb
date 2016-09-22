# This migration comes from payment (originally 20160918064813)
class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.string :transaction_no, limit: 64
      t.string :remote_ip, limit: 64
      t.integer :pay_type, limit: 4
      t.integer :status, limit: 4
      t.integer :source, limit: 4
      t.string :type, limit: 64

      t.timestamps null: false
    end

    # 数据导入
    Withdraw.find_each(:batch_size => 500) do |w|
      values = %w(user_id amount transaction_no remote_ip pay_type status source type created_at updated_at).map do |col|
        case col
          when 'user_id'
            w.account.accountable.id
          when 'amount'
            w.value
          when 'transaction_no'
            "'#{Util.random_order_no}'"
          when 'remote_ip'
            "''"
          when 'pay_type'
            0
          when 'status'
            3
          when 'source'
            0
          when 'type'
            "'Payment::Withdraw'"
          when 'created_at', 'updated_at'
            "'#{w.send(col).to_s[0,19]}'"
        end
      end
      sql = "insert into payment_transactions (user_id,amount,transaction_no,remote_ip,pay_type,status,source,type,created_at,updated_at) values (#{values.join(",")})"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
