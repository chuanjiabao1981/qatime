module LiveStudio
  # 专属课任务
  class Task < ActiveRecord::Base
    default_scope { order("id desc") }

    belongs_to :taskable, polymorphic: true
    belongs_to :user

    belongs_to :parent, class_name: 'LiveStudio::Task'

    delegate :name, to: :user, prefix: true
    delegate :id, :name, :model_name, to: :taskable, prefix: :course

    validates :taskable, :user, presence: true

    before_validation :copy_parent
    def copy_parent
      return unless parent
      self.title ||= parent.title
      self.body ||= parent.body
      self.taskable ||= parent.taskable
    end

    def asyn_send_task_message
      LiveStudio::TaskMessageJob.perform_later(id, 'create')
    end

    # 发送群组消息
    def send_task_message(action)
      msg = { type: model_name.to_s, event: action, title: title, body: body, taskable_id: taskable_id, taskable_type: taskable_type }.to_json
      Netease::IM::Service.send_msg(
        from: user.chat_account.accid, # 教师accid
        ope: 1, # 群消息
        to: taskable.chat_team.team_id, # 发送群组ID
        type: '100', # 自定义消息
        body: msg
      )
    end
  end
end
