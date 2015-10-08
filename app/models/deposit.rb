class Deposit < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  def __deposit(user_id)
    self.transaction do
      user = User.find(user_id)
      account = user.account
      account.lock!
      account.money += value
      account.save
      self.user_id = user_id
      self.save
    end
  end

end
