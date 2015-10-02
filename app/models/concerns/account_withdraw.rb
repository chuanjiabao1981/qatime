module AccountWithdraw
  extend ActiveSupport::Concern
  included do

    def withdraw_process(object, account)
      # 先暂时写死，价格一分钟一元
      price_per_minute = 1
      customized_course = CustomizedCourse.find(object.customized_course_id)
      object.transaction do
        #防止视频被修改，这里要对关键对象加锁
        object.lock!
        video = object.video
        video.lock!

        if video and video.duration and video.duration > 0
          minute = Float(video.duration) / 60
          fee_value = minute * price_per_minute

          # 生成费用单子，
          fee = object.build_fee
          fee.value = fee_value
          fee.customized_course_id = customized_course
          fee.save!

          #获取学生账户
          student_account = Student.find(customized_course.student_id).account.lock!
          account.lock!
          #
          student_account.money -= fee_value;
          account.money += fee_value;

          student_account.save!
          account.save!


          object.status = true
          object.save!
        end
      end
    end
  end
end