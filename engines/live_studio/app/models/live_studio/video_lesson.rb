require 'encryption'
module LiveStudio
  class VideoLesson < ActiveRecord::Base
    has_soft_delete
    extend Enumerize
    prepend PlayRecordWithJob
    include Resource::Quotable

    has_one :video_file, through: :quote, class_name: 'Resource::VideoFile', source: 'file'

    delegate :video_format_duration, :video_capture_url, to: :video_file, allow_nil: true

    accepts_nested_attributes_for :quote
    validates_associated :quote

    attr_accessor :replay_times
    attr_accessor :start_time_hour, :start_time_minute, :_update

    default_scope { order(:pos) }

    belongs_to :video

    delegate :teacher_percentage, :publish_percentage, :base_price, :workstation, :grade, :subject, :publicize, to: :video_course
    delegate :id, :name, to: :video_course, prefix: :course

    enum status: {
             missed: -1, # 已错过
             init: 0, # 初始化
             ready: 1, # 等待上课
             teaching: 2, # 上课中
             paused: 3, # 暂停中 意外中断可以继续直播
             closed: 4, # 直播结束 可以继续直播
             finished: 5, # 已完成 不可继续直播
             billing: 6, # 结算中
             completed: 7 # 已结算
         }

    enumerize :duration, in: {
                           minutes_30: 30,
                           minutes_45: 45,
                           hours_1: 60,
                           hours_half_90: 90,
                           hours_2: 120,
                           hours_half_150: 150,
                           hours_3: 180,
                           hours_half_210: 210,
                           hours_4: 240
                       }, i18n_scope: "enumerize.live_studio/lessons.durations", scope: true, predicates: { prefix: true }
    belongs_to :video_course, counter_cache: true
    belongs_to :teacher, class_name: '::Teacher' # 区别于course的teacher防止课程中途换教师

    has_many :play_records, -> { where(product_type: 'LiveStudio::VideoCourse') }, class_name: 'PlayRecord', foreign_key: :lesson_id # 听课记录
    has_many :billings, as: :target, class_name: 'Payment::Billing' # 结算记录

    has_many :live_studio_lesson_notifications, as: :notificationable, dependent: :destroy
    has_many :ticket_items, as: :target

    validates :name, presence: true

    def short_description(len = 20)
      description.try(:truncate, len)
    end

    # 记录播放记录
    # TODO 由于没有找到好的准确记录播放记录的方案，暂时假定所有的ticket都观看了直播
    def instance_play_records(immediately = false)
      # 防止重复记录
      user_ids = play_records.map(&:user_id)
      # 查询所有的可用听课证
      video_course.tickets.available.find_each(batch_size: 50) do |ticket|
        next if user_ids.include?(ticket.student_id)
        ticket.record_play(play_records_params.merge(user_id: ticket.student_id, ticket_id: ticket.id))
      end
    end

    def billing_amount
      @billing_amount ||= ticket_items.billingable.includes(:ticket).map(&:ticket).sum(&:lesson_price)
    end

    # 点播次数
    def total_play_times
      play_records.replay.count
    end

    # 获取直播录像
    def sync_replays
      course.channels.each do |c|
        c.sync_video_for(self) if c.board?
      end
      synced! if channel_videos.count > 0
      # 设置合并任务
      ReplaysMergeWorker.perform_async(id) if synced?
    end

    # 视频回放开始时间
    def replays_start_at
      (live_start_at.to_i - 6.minutes) * 1000
    end

    # 视频回放结束时间
    def replays_end_at
      live_end_at.nil? ? Time.now.to_i * 1000 : (live_end_at.to_i + 6.minutes) * 1000
    end

    # 剩余回放时间
    def left_replay_times
      return 0 unless replay_times
      [LiveStudio::ChannelVideo::TOTAL_REPLAY - replay_times, 0].max
    end

    # 视频时长单位分钟
    def duration_minutes
      (real_time.to_i / 60.0).round(2)
    end

    # 是否可观看
    def play_for?(user)
      return false if user.nil?
      return true if user.admin?
      return false unless video_course.buy_tickets.where(student_id: user.id).available.exists?
      return false unless video_course.play_authorize(user, nil)
      true
    end

    private

    # 过期试听证
    def used_taste_tickets
      video_course.taste_tickets.pre_used.map(&:used!)
    end

    # 系统服务费
    def system_fee!(money, billing)
      system_money = VideoCourse::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      increase_cash_admin_account(system_money, billing)
      system_money
    end

    # 教师分成
    def teacher_fee!(money, billing)
      teacher_money = money * video_course.teacher_percentage.to_f / 100
      teacher.cash_account!.earning(teacher_money, billing.target, billing, "课程完成 - #{id} - #{name} - #{teacher_money}/#{money}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money, billing)
      video_course.workstation.cash_account!.earning(money, billing.target, billing, "课程完成 - #{id} - #{name}")
    end

    # 结算完成后
    # 系统账户 支出结算金额
    def decrease_cash_admin_account(money, billing)
      CashAdmin.decrease_cash_account(money, billing, '课程完成 - 支出结算')
    end

    # 结算完成后
    # 系统账户 收取服务费
    def increase_cash_admin_account(money, billing)
      CashAdmin.increase_cash_account(money, billing, '课程完成 - 系统服务费')
    end

    def play_records_params
      {
          course_id: video_course_id,
          lesson_id: id,
          start_time_at: live_start_at,
          end_time_at: live_end_at,
          tp: 'student',
          product_id: video_course_id,
          product_type: 'LiveStudio::VideoCourse'
      }
    end

    after_commit :decrement_course_counter, on: [:update]
    def decrement_course_counter
      LiveStudio::VideoCourse.decrement_counter(:video_lessons_count, video_course.id) if deleted_at.present? && video_course
    end

    before_save :set_real_time
    def set_real_time
      return unless video_file
      self.real_time = video_file.video_duration
      self.duration = video_file.video_duration
    end
  end
end
