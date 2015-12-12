desc 'After delete invalid account record， rebuild account for exist users'
task :re_build_account_for_exist_users => :environment do
  User.all.each do |user|
   if user.role == "student" or user.role == "teacher"
     if user.account.nil?
       account = user.build_account
       account.save
     end
   end
  end
end