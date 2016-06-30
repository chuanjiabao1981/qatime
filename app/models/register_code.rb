class RegisterCode < ActiveRecord::Base
  scope :able_code, ->{ where(state: 'available')}

  attr_accessor :number

  belongs_to :user
  belongs_to :school



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

  def self.batch_make(number, school)
    check_message = number_validate(number)
    if "OK" != check_message
      return check_message
    end

    current_time = Time.new()
    timestamp = current_time.to_i.to_s

    for value in 1..number.to_i
      register_code = RegisterCode.new
      register_code.make_value
      register_code.school = school
      register_code.batch_id = timestamp
      register_code.number = 1
      register_code.save
    end

    return "OK"
  end

  def self.number_validate(number)
    if not number.to_i.to_s == number
      return "number必须为整数"
    else
      if number.to_i <= 0 or number.to_i > 10000
        return "number必须介于1和10000之间"
      end
    end

    return "OK"
  end

  def self.get_available_register_codes(school, batch_id = nil)
    if not batch_id.nil? and not batch_id.blank?
      register_codes = RegisterCode.where(:school_id=> school.id, :state=>"available", :batch_id => batch_id)
    else
      register_codes = RegisterCode.where(:school_id=> school.id, :state=>"available")
    end
    return register_codes

  end

end