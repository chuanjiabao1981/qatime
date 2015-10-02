desc 'After refactor account model, delete invalid account record.'
task :invalid_account_delete => :environment do
  Account.all.each do |account|
    if account.user_id.nil?
      account.destroy
    end
  end
end