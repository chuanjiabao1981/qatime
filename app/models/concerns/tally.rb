module Tally
  extend ActiveSupport::Concern
  included do

    has_one  :fee, as: :feeable

    scope :valid_tally_unit, -> { where("customized_course_id is not null").where(:status => "open") }


    ##计算
    def __create_fee(video,price_per_minute)
      minute                 = Float(video.duration) / 60
      fee_value              = format("%.2f",minute * price_per_minute).to_f
      return unless fee_value > 0
      fee = self.build_fee
      fee.value = fee_value
      fee.customized_course_id        = self.customized_course_id
      fee.price_per_minute            = price_per_minute
      fee.video_duration              = video.duration
      fee.save!
      fee
    end

    ##扣款
    def __charge_fee(fee)
      customized_course           = CustomizedCourse.find(self.customized_course_id)
      consumption_account         = Student.find(customized_course.student_id).account
      consumption_account.lock!
      consumption_account.money   = consumption_account.money - fee.value
      consumption_account.consumption_records.create!(fee: fee,value: fee.value)
      consumption_account.save!
    end

    ##分账给老师
    def __split_fee_to_teacher(teacher_id,fee,percent)
      teacher_account            = Teacher.find(teacher_id).account
      teacher_value              = format("%.2f",fee.value * percent).to_f
      teacher_account.lock!
      teacher_account.money      = teacher_account.money + teacher_value
      teacher_account.earning_records.create!(fee: fee,percent: percent,value: teacher_value)
      teacher_account.save!
    end

    ##分账给公司
    def __split_fee_to_company(fee,percent)

    end
    ##分账
    def __split_fee(teacher_id,fee)
      __split_fee_to_teacher(teacher_id,fee,1.0)
      __split_fee_to_company(fee,0.0)
    end



    def keep_account(teacher_id, &block)
      return unless self.video and self.video.duration and self.video.duration > 0
      self.transaction do
        self.lock!
        self.video.lock!
        begin
            fee = __create_fee(self.video,APP_CONSTANT["price_per_minute"].to_f)
            return unless fee and fee.value > 0
            __charge_fee(fee)
            __split_fee(teacher_id,fee)
            self.status = "closed"
            self.save!
            ##这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
            if block_given?
              yield
            end
        rescue Exception => e
          Rails.logger.error("#{e.to_s} \n #{self.model_name.to_s} \n #{self.to_json}")
          raise ActiveRecord::StatementInvalid, "#{e.to_s} \n #{self.model_name.to_s} \n #{self.to_json}"
        end
      end
    end

  end
end