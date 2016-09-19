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
end
