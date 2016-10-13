class PushWorker
  include Sidekiq::Worker

  # 推送任务
  def perform(push_message_id)
    push_message = PushMessage.find(push_message_id)
    UserService::PushDirector.push(push_message)
  end
end
