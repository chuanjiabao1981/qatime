# desc "Explaining what the task does"
# task :payment do
#   # Task goes here
# end

namespace :payment do
  desc "迁移用户充值记录"
  task rechage_history: :environment do
    raise "不能重复导入" if Payment::Recharge.where(pay_type: 10).count > 0

    count = 0
    puts "开始导入"
    Deposit.includes(account: :accountable).find_each(batch_size: 500) do |deposit|
      count += 1
      num = '%04d' % rand(1000)
      no = deposit.created_at.to_s(:number) + num
      Payment::Recharge.create(amount: deposit.value, user: deposit.account.accountable, transaction_no: no, pay_type: :offline, status: 3, source: :web, created_at: deposit.created_at, updated_at: deposit.updated_at)
      puts "完成记录: #{count}条" if count % 100 == 0
    end
    puts "导入完成 共#{count}条"
  end

  desc "账户余额迁移"
  task migrate_to_cash_account: :environment do
    count = 0
    puts "开始迁移"
    Account.includes(:accountable).find_each(batch_size: 500) do |account|
      next if account.accountable.nil?
      cash_account = account.accountable.cash_account!
      next if cash_account.migrated
      cash_account.total_income = account.total_income
      cash_account.total_expenditure = account.total_expenditure
      cash_account.balance += account.money
      cash_account.migrated = true
      cash_account.save
      count += 1
      puts "完成记录: #{count}条" if count % 100 == 0
    end
  end

  desc "收益记录迁移"
  task migrate_to_change_records: :environment do
    # raise "不能重复导入" if Payment::Billing.where(target_type: 'Correction').count > 0
    count = 0
    puts "开始迁移"
    Fee.includes(:feeable, :customized_course).find_each(batch_size: 500) do |fee|
      next if fee.feeable.nil?
      next if Payment::Billing.where(target_id: fee.feeable_id, target_type: fee.feeable_type).count > 0
      billing = Payment::Billing.create(target: fee.feeable, total_money: fee.sale_price, created_at: fee.created_at, updated_at: fee.updated_at, summary: "#{fee.feeable.model_name.human} - #{fee.feeable.id}结算")
      fee.earning_records.each do |record|
        accountable = record.account.accountable
        next if accountable.nil?
        cash_account = accountable.cash_account!
        cash_account.earning_records.create(different: record.value, billing: billing, summary: billing.summary,
                                            created_at: record.created_at, updated_at: record.updated_at, owner: accountable, target: billing.target, amount: record.value)
      end
      fee.consumption_records.each do |record|
        accountable = record.account.accountable
        next if accountable.nil?
        cash_account = accountable.cash_account!
        cash_account.consumption_records.create(different: -record.value.abs, billing: billing, summary: billing.summary,
                                            created_at: record.created_at, updated_at: record.updated_at, owner: accountable, target: billing.target, amount: -record.value.abs)
      end
      count += 1
      puts "完成记录: #{count}条" if count % 100 == 0
    end
  end

  desc '提现记录迁移'
  task migrate_to_withdraw: :environment do
    raise "不能重复导入" if Payment::Withdraw.count > 0
    # 数据导入
    ::Withdraw.find_each(:batch_size => 500) do |w|
      values = [
        w.account.accountable.id,
        w.value,
        "'#{Util.random_order_no}'",
        "''",
        0,
        1,
        0,
        "'Payment::Withdraw'",
        "'#{w.created_at.to_s[0,19]}'",
        "'#{w.updated_at.to_s[0,19]}'"
      ]
      sql = "insert into payment_transactions (user_id,amount,transaction_no,remote_ip,pay_type,status,source,type,created_at,updated_at) values (#{values.join(",")})"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
