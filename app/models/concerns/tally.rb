module Tally
  extend ActiveSupport::Concern
  included do
    scope :by_teacher, lambda {|t| where(teacher_id: t) if t}
    scope :valid_tally_unit, -> { where("customized_course_id is not null").where(:status => "open") }

    def create_fee
      price_per_minute = 1
      # 生成费用单子
      video = self.video
      if video and video.duration and video.duration > 0
        video.lock!
        minute = Float(video.duration) / 60
        fee_value = format("%.1f",minute * price_per_minute).to_f
        fee = self.build_fee
        fee.value = fee_value
        fee.customized_course_id = self.customized_course_id
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
        fee = self.create_fee

        if fee and fee.value > 0
          #获取学生账户
          student_account = Student.find(customized_course.student_id).account.lock!
          teacher = Teacher.find(teacher_id)
          account = teacher.account
          account.lock!
          student_account.money -= fee.value;
          account.money += fee.value;
          student_account.save!
          account.save!
          self.status = "closed"
          self.save!
        end
      end
    end

    def keep_account_wrong(teacher_id)
      # 先暂时写死，价格一分钟一元
      customized_course = CustomizedCourse.find(self.customized_course_id)
      self.transaction do
        #防止视频被修改，这里要对关键对象加锁
        self.lock!
        fee = self.create_fee

        if fee and fee.value > 0
          #获取学生账户
          student_account = Student.find(customized_course.student_id).account.lock!
          teacher = Teacher.find(teacher_id)
          account = teacher.account
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

  end
end