# desc "Explaining what the task does"
# task :payment do
#   # Task goes here
# end

namespace :payment do
  desc "迁移用户充值记录"
  task rechage_history: :environment do
    count = 0
    puts "开始导入"

    Student.includes(:account).find_each(batch_size: 500) do |student|
      next unless student.account
      next if student.payment_recharge.where(pay_type: 10).count > 0
      student.account.deposits.find_each(batch_size: 50) do |deposit|
        count += 1
        num = '%04d' % rand(1000)
        no = deposit.created_at.to_s(:number) + num
        Payment::Recharge.create(user: student, transaction_no: no, pay_type: :offline, status: 3, source: :web, created_at: deposit.created_at, updated_at: deposit.updated_at)
        puts "完成记录: #{count}条" if count % 100 == 0
      end
    end
    puts "导入完成 共#{count}条"
  end
end
