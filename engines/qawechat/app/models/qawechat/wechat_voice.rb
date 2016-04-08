module Qawechat
  class WechatVoice < ActiveRecord::Base
    has_one :voice, as: :voicable, class_name: "Media::Voice"

    include AASM

    aasm column: :state do
      state :not_convert, initial: true
      state :converting
      state :convert_success
      state :convert_fail

      #异步转换
      event :in_queue, after: :start_convert do
        transitions from: :not_convert, to: :converting
      end

      event :convert_process_finish do
        transitions from: :converting, to: :convert_success
      end

      event :convert_process_exec_error, after: :send_alert do
        transitions from: :converting, to: :convert_fail
      end

    end

    def start_convert
      WechatVoiceConvertWorker.perform_async(self.id)
    end

    def send_alert
      error_message = self.id.to_s + " voice convert failed."
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: error_message)
    end
  end
end
