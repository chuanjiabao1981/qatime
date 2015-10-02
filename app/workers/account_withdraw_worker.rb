class AccountWithdrawWorker

=begin
  此类负责将输入的老师帐号对应的未结账视频做结账
=end

  include Sidekiq::Worker
  sidekiq_options :queue => :account_withdraw, :retry => false, :backtrace => true

  ##输入老师id，将
  def perform(id)
    teacher = Teacher.find(id)
    account = teacher.account
    # 获取到该老师所有的专属课堂的费用

    CustomizedTutorial.where("teacher_id=? and status=? and customized_course_id is NOT NULL", teacher.id, false).each do |customized_tutorial|
      withdraw_process(customized_tutorial, account)
    end

    # 获取到该老师所有作业批改的费用
    Correction.where("teacher_id=? and status=? and customized_course_id is NOT NULL", teacher.id, false).each do |correction|
      withdraw_process(customized_tutorial, account)
    end

    Reply.where("author_id=? and status=? and customized_course_id is NOT NULL", teacher.id, false).each do |reply|
      withdraw_process(reply, account)
    end
  end

  #整个函数来做整个的处理
  private
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
