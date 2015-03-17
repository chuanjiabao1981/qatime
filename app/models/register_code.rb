class RegisterCode < ActiveRecord::Base

  belongs_to :teacher
  belongs_to :school

  validates_presence_of :school

  def make_value
    self.value = rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s +
        rand(10).to_s + "-" +format("%03d",Time.new().to_i%1000)
  end

  # 如果code_value验证成功
  # expired = true  则使得此code_value.state = expired
  def self.verification(code_value, school_id,expired=true)

    a = RegisterCode.where("value=? and state=? and teacher_id is NULL and school_id = ?",code_value,"available",school_id).take
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
