namespace :user_token do
  desc "迁移用户登录remember token"
  task migrate: :environment do
    count = 0
    puts "开始导入"
    User.includes(:login_tokens).find_each(batch_size: 500) do |user|
      next if user.remember_token.blank? || user.login_tokens.find { |t| t.client_type == 'web' }
      count += 1
      puts "完成记录: #{count}条" if count % 100 == 0
      user.login_tokens.create(digest_token: user.remember_token, client_type: 'web')
    end
    puts "导入完成 共#{count}条"
  end
end
