class RegisterCode < ActiveRecord::Base

  belongs_to :user
  belongs_to :school

  attr_accessor :number


  def make_value
    self.value = rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s + "-" +format("%03d",(Time.new().to_i+rand(1000))%1000)
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

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      sub_column_names = []
      sub_column_names.append("id")
      sub_column_names.append("value")
      sub_column_names.append("state")
      sub_column_names.append("created_at")

      #csv << sub_column_names
      all.each do |register_code|
        csv << register_code.attributes.values_at(*sub_column_names)
      end
    end
  end

end