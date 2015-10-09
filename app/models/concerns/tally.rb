module Tally
  extend ActiveSupport::Concern
  included do
    scope :valid_tally_unit, -> { where("customized_course_id is not null").where(:status => "open") }

    def fee_value_compute
      video = self.video
      if video and video.duration and video.duration > 0
        video.lock!
        minute = Float(video.duration) / 60
        fee_value = format("%.1f",minute * APP_CONFIG[:price_per_minute]).to_f
        fee_value
      end
    end

    def __create_fee(teacher_account, student_account)
      fee_value = self.fee_value_compute
      if fee_value and fee_value > 0
        fee = self.build_fee
        fee.value = fee_value
        fee.customized_course_id = self.customized_course_id
        fee.student_account_id = student_account.id
        fee.teacher_account_id = teacher_account.id
        fee.save!
        fee
      end
    end

    def keep_account(teacher_id)
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
              student_account.money -= fee.value
              account.money += fee.value
              student_account.save!
              account.save!
              self.status = "closed"
              self.save!
          end
        rescue Exception => e
          puts e.to_s
          puts "keep_account Wrong " + self.as_json.to_s
          raise ActiveRecord::StatementInvalid, "keep_account Wrong " + self.as_json.to_s
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
        puts fee.to_json
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
          puts "keep_account Wrong " + self.as_json.to_s
          raise ActiveRecord::StatementInvalid, "keep_account Wrong " + self.as_json.to_s
        end
      end
    end

  end
end