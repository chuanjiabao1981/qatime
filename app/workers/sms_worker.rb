
module SmsUtil
  def send_message(mobile,content)
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
  QUESTION_MODIFY_NOTIFICATION = :question_modify_notify
  REGISTRATION_NOTIFICATION    = :registration_notify
  ANSWER_CREATE_NOTIFICATION   = :answer_create_notify
  TOPIC_CREATE_NOTIFICATION    = :topic_create_notify

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
                     "【答疑时间】#{question.student.name}，你好，#{teacher.name}老师回复了你问题，请及时查看并给出相应评论。")
      rescue Exception => e
        logger.info e.message
        logger.info e.backtrace.inspect
      end
    end
    def registration_notify(options)
      user = User.find(options["id"])
      begin
        send_message(user.mobile,
                     "【答疑时间】#{user.name}，你好，欢迎注册答疑时间! 请使用360极速浏览器或者360安全浏览器访问本网站。")

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
                       "【答疑时间】#{question.student.name}向您提了一个问题，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。")
        rescue Exception => e
          logger.info e.message
          logger.info e.backtrace.inspect
        end
      end
    end
    def question_modify_notify(options)
      question = Question.find(options["id"])
      question.teachers.each do |teacher|
        begin
          send_message(teacher.mobile,
                       "【答疑时间】#{question.student.name}对一个问题进行了修改，请您查看#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。")
        rescue Exception => e
          logger.info e.message
          logger.info e.backtrace.inspect
        end
      end
    end
    def topic_create_notify(options)
      topic = Topic.find(options["id"])
      if topic.author_id != topic.teacher_id
       message_body =  "【答疑时间】#{topic.teacher.name}，你好，#{topic.author.name}在公共课程中发起了讨论，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"

       if topic.topicable_type == CustomizedTutorial.to_s or topic.topicable_type == CustomizedCourse.to_s
         message_body =  "【答疑时间】#{topic.teacher.name}，你好，#{topic.author.name}在#{CustomizedCourse.model_name.human}中发起了讨论，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
       end
       _send_message do
         send_message(topic.teacher.mobile,message_body)
       end
      end
    end

    def reply_create_notify(options)
      reply = Reply.find(options["id"])
      return unless reply
      topic = reply.topic
      return unless topic
    end

    def _send_message(&block)
      begin
        yield
      rescue Exception => e
        logger.info e.message
        logger.info e.backtrace.inspect
      end
    end
end
