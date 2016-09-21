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
end
