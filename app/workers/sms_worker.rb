
module SmsUtil
  def send_message(mobile,content)
    return if Rails.env.test?
    uri = URI.parse('http://yunpian.com/v1/sms/send.json')

    s = Net::HTTP.post_form(uri,
                            {:apikey=>"17d598eddb405659a1640ad6fa1cc985",
                             :mobile=> mobile,
                             :text=> content
                            }
    )
    result = JSON.parse(s.body)

    if result["code"].to_i != 0
      raise StandardError ,result
    end
  end
end
class SmsWorker

  QUESTION_CREATE_NOTIFICATION = :question_create_notify
  # HOMEWORK_CREATE_NOTIFICATION = :homework_create_notify
  # TUTORIAL_CREATE_NOTIFICATION = :tutorial_create_notify
  QUESTION_MODIFY_NOTIFICATION = :question_modify_notify
  REGISTRATION_NOTIFICATION    = :registration_notify
  ANSWER_CREATE_NOTIFICATION   = :answer_create_notify
  # TOPIC_CREATE_NOTIFICATION    = :topic_create_notify
  # REPLY_CREATE_NOTIFICATION    = :reply_create_notify
  NOTIFY                       = :notify2
  SYSTEM_ALARM                 = :system_alarm
  SEND_CAPTCHA                 = :send_captcha
  REGISTER_CAPTCHA             = :register_captcha
  GET_PASSWORD_BACK            = :get_password_back
  WITHDRAW_CASH                = :withdraw_cash
  PAYMENT_PASSWORD             = :payment_password

  # 上课提醒短信
  LIVE_STUDIO_LESSON_START_NOTIFICATION = :live_studio_lesson_start

  include Sidekiq::Worker
  include SmsUtil

  sidekiq_options :queue => :sms, :retry => false, :backtrace => true
  require 'net/http'
  require 'json'

  def perform(notification_type,options={})
    send notification_type,options
  end


  private
    def answer_create_notify(options)
      question = Question.find(options["id"])
      teacher  = Teacher.find(options["teacher_id"])
      begin
        send_message(question.student.mobile,
                     "【答疑时间】#{question.student.view_name}，你好，#{teacher.view_name}回复了你问题，请及时查看并给出相应评论。")
      rescue Exception => e
        logger.info e.message
        logger.info e.backtrace.inspect
      end
    end
    def registration_notify(options)
      user = User.find(options["id"])
      begin
        send_message(user.mobile,
                     "【答疑时间】#{user.view_name}，你好，欢迎注册答疑时间! 请使用360极速浏览器或者360安全浏览器访问本网站。")

      rescue Exception => e
        logger.info e.message
        logger.info e.backtrace.inspect
      end
    end
    def question_create_notify(options)
      question = Question.find(options["id"])
      question.teachers.each do |teacher|
        begin
          send_message(teacher.mobile,
                       "【答疑时间】#{question.student.view_name}向您提了一个问题，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。")
        rescue Exception => e
          if ENV["RAILS_ENV"] != "test"
            logger.info e.message
            logger.info e.backtrace.inspect
          else
            #测试环境do nothing
            #logger.info e.message
          end
        end
      end
    end
    def question_modify_notify(options)
      question = Question.find(options["id"])
      question.teachers.each do |teacher|
        begin
          send_message(teacher.mobile,
                       "【答疑时间】#{question.student.view_name}对一个问题进行了修改，请您查看#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。")
        rescue Exception => e
          logger.info e.message
          logger.info e.backtrace.inspect
        end
      end
    end
    # def topic_create_notify(options)
    #   topic = Topic.find(options["id"])
    #   if topic.author_id != topic.teacher_id
    #    message_body =  "【答疑时间】#{topic.teacher.view_name}，你好，#{topic.author.view_name}在公共课程中发起了讨论，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
    #
    #    if topic.topicable_type == CustomizedTutorial.to_s or topic.topicable_type == CustomizedCourse.to_s
    #      message_body =  "【答疑时间】#{topic.teacher.view_name}，你好，#{topic.author.view_name}在#{CustomizedCourse.model_name.human}中发起了讨论，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
    #    end
    #    _send_message do
    #      send_message(topic.teacher.mobile,message_body)
    #    end
    #   end
    # end

  # def reply_create_notify(options)
  #   reply = Reply.find(options["id"])
  #   return unless reply
  #   topic = reply.topic
  #   return unless topic
  #   # 只有是老师回复学生才需要通知
  #   return unless topic.author.student? and reply.author.teacher?
  #   mobile        = topic.author.mobile
  #   message_body  = "【答疑时间】#{topic.author.view_name}，你好，#{reply.author.view_name}回复了你在#{topic.topicable.model_name.human}发起讨论，请关注#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
  #   _send_message do
  #     send_message(mobile,message_body)
  #   end
  # end

  # def homework_create_notify(options)
  #
  #   homework = Homework.find(options["id"])
  #   return unless homework
  #   customized_course = homework.customized_course
  #   return unless customized_course
  #   teacher           = homework.teacher
  #   student           = customized_course.student
  #   message_body      = "【答疑时间】#{student.view_name}，你好，#{teacher.view_name}在#{CustomizedCourse.model_name.human}中布置了#{Homework.model_name.human}，请关注#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
  #   _send_message do
  #     send_message(student.mobile,message_body)
  #   end
  # end

  def notify(options)
    from      = options["from"]
    to        = options["to"]
    message   = options["message"]
    mobile    = options["mobile"]
    sms_info  = "【答疑时间】#{to}，你好，#{from}#{message}#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
    _send_message do
      send_message(mobile,sms_info)
    end
  end

  def notify2(options)
    to        = options["to"]
    message   = options["message"]
    mobile    = options["mobile"]
    sms_info  = "【答疑时间】#{to}，你好，#{message}#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
    _send_message do
      send_message(mobile,sms_info)
    end
  end
  # def tutorial_create_notify(options)
  #   tutorial = CustomizedTutorial.find(options["id"])
  #   return unless tutorial
  #   customized_course = tutorial.customized_course
  #   return unless customized_course
  #   student           = customized_course.student
  #   teacher           = tutorial.teacher
  #   message_body      = "【答疑时间】#{student.view_name}，你好，#{teacher.view_name}在#{CustomizedCourse.model_name.human}中上传了#{CustomizedTutorial.model_name.human}，请关注#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
  #   _send_message do
  #     send_message(student.mobile,message_body)
  #   end
  # end

  def system_alarm(options)
    return unless Settings[:alert_mobiles].is_a?(Array)
    error_message = options["error_message"]
    Settings[:alert_mobiles].each do |mobile|
      send_message(mobile, "【答疑时间】管理员，你好，#{error_message}，请关注#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}，谢谢。")
    end
  rescue StandardError => e
    logger.info e.message
    logger.info e.backtrace.inspect
  end

  def send_captcha(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    case options["type"]
    when 'edit_email'
      type = "邮箱"
    when 'find_password'
      type = "密码"
    when 'edit_login_mobile'
      type = "绑定的手机"
    when 'edit_parent_phone'
      type = "绑定的家长手机"
    end
    begin
      send_message(mobile,
       "【答疑时间】您好，您正在修改#{type}，验证码: #{captcha}，如果不是您本人操作，请尽快修改登录密码")
    rescue StandardError => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

  def get_password_back(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    send_message(mobile, "【答疑时间】您好，您正在修改登陆密码，验证码: #{captcha}，如果不是您本人操作，请尽快修改登录密码")
  rescue StandardError => e
    logger.info e.message
    logger.info e.backtrace.inspect
  end

  def register_captcha(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    begin
      send_message(mobile,
       "【答疑时间】您好，您正在注册答疑时间，验证码: #{captcha}，如果不是您本人操作，请忽略")
    rescue Exception => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

  def withdraw_cash(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    begin
      send_message(mobile,
                   "【答疑时间】您好，您的账户正在申请提现，验证码: #{captcha}，请勿透露给他人")
    rescue Exception => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

  def payment_password(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    begin
      send_message(mobile,
                   "【答疑时间】您好，您的账户正在修改支付密码，验证码: #{captcha}，请勿透露给他人")
    rescue Exception => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

  def live_studio_lesson_start(options)
    mobile = options["mobile"]
    notification = Notification.find(options["id"])
    begin
      send_message(mobile,
                   "【答疑时间】#{notification.notice_content}")
    rescue Exception => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

    def _send_message(&block)
      begin
        yield
      rescue Exception => e
        if ENV["RAILS_ENV"] != "test"
          logger.info e.message
          logger.info e.backtrace.inspect
        else
          #测试环境
        end

      end
    end

end
