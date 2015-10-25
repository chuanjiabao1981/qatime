task :account_refactory_for_polymorphic => :environment do
  Account.all.each do |account|
   if account.accountable_type.nil?
      account.accountable_type = "User"
      account.save
   end
  end
end