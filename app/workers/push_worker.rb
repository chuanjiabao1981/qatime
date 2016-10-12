class PushWorker
  include Sidekiq::Worker

  # 推送任务
  def perform(push_message)
    UserService::PushDirector.push(push_message)
  end
end
