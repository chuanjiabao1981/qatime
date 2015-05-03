
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
  sidekiq_options :queue => :sms, :retry => false, :backtrace => true
  require 'net/http'
  require 'json'

  def perform(id)
    QuestionCreateNotification.new(id).notify
  end
end

class QuestionCreateNotification
  include SmsUtil

  def initialize(id)
    @question = Question.find(id)
  end

  def notify
    @question.learning_plan.teachers.each do |teacher|
      send_message(teacher.mobile,content)
    end
  end

private
  def content
    "【答疑时间】#{@question.student.name}向您提了一个问题，请您回复#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}。"
  end
end
