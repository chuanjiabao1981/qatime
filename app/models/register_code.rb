class RegisterCode < ActiveRecord::Base

  belongs_to :user

  def make_value
    self.value = rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s + "-" +format("%03d",Time.new().to_i%1000)
  end

  def get_state_human_name
    if self.state == 'available'
      "可用"
    else
      "不可用"
    end
  end
  # 如果code_value验证成功
  # expired = true  则使得此code_value.state = expired
  def self.verification(code_value, expired=true)

    a = RegisterCode.where("value=? and state=? and user_id is NULL",code_value,"available").take
    if a
      a.state = "expired"
      # TODO: 可以优化加锁
      if expired
        a.save
      end
      a
    else
      nil
    end
  end

end
