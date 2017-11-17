module Resource
  class Quote < ActiveRecord::Base
    belongs_to :file, counter_cache: true
    belongs_to :quoter, polymorphic: true

    # validates :quoter, :file, presence: true

    delegate :type, :file_size, :ext_name, :file_url, to: :file
    delegate :name, to: :file, prefix: true

    after_commit :asyn_send_team_message, on: :create

    def asyn_send_team_message
      return unless quoter.is_a?(LiveStudio::Group)
      Resource::FileMessageJob.perform_later(id, 'create')
    end

    def message(action)
      { type: 'Resource::File', id: file_id, event: action, title: file_name, body: file_name, taskable_id: quoter_id, taskable_type: quoter_type }
    end

    # 发送群组消息
    def send_team_message(action)
      return unless quoter.is_a?(LiveStudio::Group)
      msg = message(action).to_json
      Netease::IM::Service.send_msg(
        from: quoter.teacher.chat_account.accid, # 教师accid
        ope: 1, # 群消息
        to: quoter.chat_team.team_id, # 发送群组ID
        type: '100', # 自定义消息
        body: msg
      )
    end

    after_create :quote_create_feeds
    def quote_create_feeds
      feeds('create') if quoter.is_a?(LiveStudio::CustomizedGroup)
    end

    after_destroy :quote_destroy_feeds
    def quote_destroy_feeds
      feeds('destroy') if quoter.is_a?(LiveStudio::CustomizedGroup)
    end

    def feeds(event)
      Social::Feed.transaction do
        # 生成动态
        feed = Social::FileFeed.create!(feedable: self, event: event, producer: file.user, linkable: quoter, workstation: quoter.workstation, target: file)
        # 学生发布动态
        feed.feed_publishs.create!(publisher: file.user)
        # 课程发布动态
        feed.feed_publishs.create!(publisher: quoter)
      end
    end
  end
end
