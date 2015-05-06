
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
  include Sidekiq::Worker
  include SmsUtil

  sidekiq_options :queue => :sms, :retry => false, :backtrace => true
  require 'net/http'
  require 'json'

  def perform(id)
    question_create_notify(id)
  end

  private
    def question_create_notify(id)
      question = Question.find(id)
      question.learning_plan.teachers.each do |teacher|
        begin
          send_message(teacher.mobile,
                       "【答疑时间】#{question.student.name}向您提了一个问题，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。")
        rescue Exception => e
          logger.info e.message
          logger.info e.backtrace.inspect
        end
      end
    end
end
