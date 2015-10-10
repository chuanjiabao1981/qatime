module Tally
  extend ActiveSupport::Concern
  included do
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



    def keep_account(teacher_id)
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
        rescue Exception => e
          puts e.to_s
          raise ActiveRecord::StatementInvalid, "#{e.to_s} \n #{self.model_name.to_s} \n #{self.to_json}"
        end
      end
    end

    def keep_account_wrong(teacher_id)
      # 先暂时写死，价格一分钟一元
      customized_course = CustomizedCourse.find(self.customized_course_id)
      self.transaction do
        #防止视频被修改，这里要对关键对象加锁
        self.lock!
        teacher = Teacher.find(teacher_id)
        account = teacher.account
        student_account = Student.find(customized_course.student_id).account

        fee = self.__create_fee(account, student_account)
        if fee and fee.value > 0
          #获取学生账户
          student_account.lock!
          account.lock!
          student_account.money -= fee.value;
          account.money += fee.value;
          student_account.save!
          account.save!
          raise ActiveRecord::StatementInvalid, "Fake Wrong"
          self.status = "closed"
          self.save!
        end
      end
    end

    def keep_account_wrong_not_db(teacher_id)
      # 先暂时写死，价格一分钟一元
      customized_course = CustomizedCourse.find(self.customized_course_id)
      self.transaction do
        #防止视频被修改，这里要对关键对象加锁
        self.lock!
        begin
          teacher = Teacher.find(teacher_id)
          account = teacher.account
          student_account = Student.find(customized_course.student_id).account

          fee = self.__create_fee(account, student_account)
          if fee and fee.value > 0
            #获取学生账户
            student_account.lock!
            account.lock!
            student_account.money -= fee.value;
            account.money += fee.value;
            student_account.save!
            account.save!
            rails "Fake wrong"
            self.status = "closed"
            self.save!
          end
        rescue Exception => e
          logger.error "keep_account Wrong " + self.as_json.to_s
          raise ActiveRecord::StatementInvalid, "keep_account Wrong " + self.as_json.to_s
        end
      end
    end

  end
end