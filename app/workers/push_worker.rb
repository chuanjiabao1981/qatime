class PushWorker
  include Sidekiq::Worker

  # 推送任务
  def perform
    UserService::PushDirector.student_push(@content)
  end
end
