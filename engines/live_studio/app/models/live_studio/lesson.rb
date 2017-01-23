require 'encryption'
module LiveStudio
  class Lesson < ActiveRecord::Base
    has_soft_delete
    extend Enumerize

    attr_accessor :replay_times
    attr_accessor :start_time_hour, :start_time_minute, :_update
    BEAT_STEP = 10 # 心跳频率/秒

    enum replay_status: {
      unsync: 0, # 未同步
      synced: 1, # 已同步
      merging: 2, # 正在合并
      merged: 3, # 已合并
      sync_error: 98, # 同步失败
      merge_error: 99 # 合并失败
    }

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

    # default_scope { order("id asc") }
    scope :unfinish, -> { where("status < ?", Lesson.statuses[:finished]) } # 未完成的课程
    scope :unclosed, -> { where('live_studio_lessons.status < ?', Lesson.statuses[:closed]) } # 未关闭的课程
    scope :already_closed, -> { where('live_studio_lessons.status >= ?', Lesson.statuses[:closed]) } # 已关闭的课程
    scope :unstart, -> { where('status < ?', Lesson.statuses[:teaching]) } # 未开始的课程
    scope :should_complete, -> { where(status: [Lesson.statuses[:finished], Lesson.statuses[:billing]]).where("class_date < ?", Date.yesterday)} # 可以completed的课程
    scope :teached, -> { where("status > ?", Lesson.statuses[:closed]) } # 已经完成上课, 不可以继续直播的课程才算完成上课
    scope :today, -> { where(class_date: Date.today) }
    scope :since_today, -> {where('class_date > ?',Date.today)}
    scope :include_today, -> {where('class_date >= ?',Date.today)}
    scope :waiting_finish, -> { where(status: [Lesson.statuses[:paused], Lesson.statuses[:closed]])}
    scope :month, -> (month){where('live_studio_lessons.class_date >= ? and live_studio_lessons.class_date <= ?', month.beginning_of_month.to_date,month.end_of_month.to_date)}
    scope :started, -> { where("status >= ?", Lesson.statuses[:teaching])} # 已开始

    belongs_to :course, counter_cache: true
    belongs_to :teacher, class_name: '::Teacher' # 区别于course的teacher防止课程中途换教师

    has_many :play_records # 听课记录
    has_many :billings, as: :target, class_name: 'Payment::Billing' # 结算记录
    has_many :channel_videos
    has_many :replays

    has_many :live_sessions # 直播 心跳记录
    has_many :live_studio_lesson_notifications, as: :notificationable, dependent: :destroy
    has_many :ticket_items

    validates :name, :class_date, presence: true

    before_create :data_preview
    # before_save :data_confirm
    after_commit :update_course

    include AASM

    aasm column: :status, enum: true do
      state :init, initial: true
      state :missed
      state :ready
      state :teaching
      state :paused
      state :closed
      state :finished
      state :billing
      state :completed

      event :miss do
        transitions from: [:ready, :init], to: :missed
      end

      event :ready do
        transitions from: [:init, :missed], to: :ready
      end

      event :teach do
        before do
          # 第一次开始直播增加开始数量
          increment_course_counter(:started_lessons_count) if unstart?
        end
        transitions from: [:ready, :paused, :missed, :closed], to: :teaching
      end

      event :pause do
        transitions from: :teaching, to: :paused
      end

      event :close do
        before do
          # 第一次结束直播增加结束数量
          increment_course_counter(:closed_lessons_count) if live_end_at.nil?
          self.live_end_at = Time.now
        end
        transitions from: [:teaching, :paused], to: :closed
      end

      event :finish, after_commit: :instance_play_records do
        after do
          # 课程完成增加辅导班完成课程数量 & 异步更新录制视频列表
          increment_course_counter(:finished_lessons_count)
          ReplaysSyncWorker.perform_async(id)
        end
        transitions from: [:closed], to: :finished
      end

      event :complete do
        after do
          # 结算后增加辅导班结算数量
          increment_course_counter(:completed_lessons_count)
        end
        transitions from: [:finished, :billing], to: :completed
      end
    end

    after_find do |lesson|
      lesson.start_time_hour, lesson.start_time_minute = lesson.start_time.split(":") if lesson.start_time.present?
    end

    before_validation :calculate_start_and_end_time
    def calculate_start_and_end_time
      self.start_time = "#{start_time_hour}:#{start_time_minute}" if start_time_hour.present? && start_time_minute.present?
      if start_time_changed? || duration_changed?
        end_hour = format("%02d", start_time_hour.to_i + duration_value / 60)
        end_minute = format("%02d", (duration_value % 60) + start_time_minute.to_i)
        self.end_time = "#{end_hour}:#{end_minute}"
      end
    end

    def status_text(role = nil, outer = true)
      role == 'teacher' || role = 'student'
      I18n.t("lesson_status.#{role}.#{status}#{!outer && status == 'paused' ? '_inner' : ''}")
    end

    def can_play?
      ready? || teaching?
    end

    # 是否可以准备上课
    def ready_for?
      init? && class_date == Date.today
    end

    def short_description(len = 20)
      description.try(:truncate, len)
    end

    def live_time
      "#{start_time}-#{end_time}"
    end

    def live_begin_time
      "#{class_date} #{start_time}"
    end

    # 开始时间
    def start_at
      Time.parse("#{class_date} #{start_time}")
    end

    # 心跳
    def heartbeats(timestamp, beat_step, token = nil)
      @live_session = token.blank? ? new_live_session : current_live_session
      return @live_session.token if @live_session.timestamp && @live_session.timestamp >= timestamp
      @live_session.heartbeat_count += 1
      @live_session.duration += beat_step
      @live_session.heartbeat_at = Time.now
      @live_session.timestamp = timestamp
      @live_session.beat_step = beat_step
      @live_session.save
      self.heartbeat_time = Time.now
      teach if ready? || paused? || closed?
      save
      @live_session.token
    end

    def start_live_session
      new_live_session
    end

    def current_live_session
      live_sessions.last || new_live_session
    end

    def last_heartbeat_at
      current_live_session.heartbeat_at
    end

    def is_over?
      # 判断课程是否已经结束
      %w(finished billing completed).include?(status)
    end

    # 判断课程是否未开始
    # 待补课, 初始化, 待上课算作没开始
    def unstart?
      %w(missed init ready).include?(status)
    end

    # 没开始课程算作没有结束
    # 暂停中或者上课中算作没有结束
    # 结束以后重新开始算作已经结束
    # 结束以后重新开始然后暂停算作已结束
    def unclosed?
      unstart? || %w(teaching paused).include?(status)
    end

    # 是否已经结束
    def lesson_finished?
      %w(finished billing completed).include?(status)
    end

    # 记录播放记录
    # TODO 由于没有找到好的准确记录播放记录的方案，暂时假定所有的ticket都观看了直播
    def instance_play_records
      # 防止重复记录
      user_ids = play_records.map(&:user_id)
      # 查询所有的可用听课证
      course.tickets.available.find_each(batch_size: 50) do |ticket|
        next if user_ids.include?(ticket.student_id)
        ticket.record_play(play_records_params.merge(user_id: ticket.student_id, ticket_id: ticket.id))
      end
    end

    def instance_play_records_with_job(immediately = false)
      return instance_play_records_without_job if immediately
      LiveStudio::LessonPlayRecordJob.perform_later(id)
    end
    alias_method_chain :instance_play_records, :job

    def self.beat_step
      APP_CONFIG[:live_beat_step] || 10
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
      (live_start_at.to_i - 2.minutes) * 1000
    end

    # 视频回放结束时间
    def replays_end_at
      live_end_at.nil? ? Time.now.to_i * 1000 : (live_end_at.to_i + 2.minutes) * 1000
    end

    # 剩余回放时间
    def left_replay_times
      return 0 unless replay_times
      [LiveStudio::ChannelVideo::TOTAL_REPLAY - replay_times, 0].max
    end

    # 是否可以回放
    def replayable
      merged?
    end

    # 是否可观看回放
    def replayable_for?(user)
      return false if user.nil?
      return true if user.admin?
      return false unless course.buy_tickets.where(student_id: user.id).available.exists?
      return false unless course.play_authorize(user, nil)
      play_records.where(play_type: LiveStudio::PlayRecord.play_types[:replay],
                         user_id: user.id).where('created_at < ?', Date.today).count < LiveStudio::ChannelVideo::TOTAL_REPLAY
    end

    # 是否显示剩余次数
    def replays_for(user)
      return false if user.nil?
      return true if user.admin?
      course.buy_tickets.where(student_id: user.id).available.exists?
    end

    # 用户剩余播放次数
    def user_left_times(user)
      return 0 if user.nil?
      c = play_records.where(play_type: LiveStudio::PlayRecord.play_types[:replay],
                         user_id: user.id).where('created_at < ?', Date.today).count
      [LiveStudio::ChannelVideo::TOTAL_REPLAY - c, 0].max
    end

    # 合并视频
    def merge_replays
      # 摄像头视频合并
      # replays.create(video_for: ChannelVideo.video_fors['camera'],
      #                name: camera_replay_name,
      #                vids: camera_video_vids,
      #                channel: course.channels.find_by(use_for: Channel.use_fors['camera']))
      # 白板视频合并
      replays.create(video_for: ChannelVideo.video_fors['board'],
                     name: board_replay_name,
                     vids: board_video_vids,
                     channel: course.channels.find_by(use_for: Channel.use_fors['board']))
    end

    def replay_name(video_for)
      "#{Rails.env}_lesson_#{id}_#{video_for}_replay"
    end

    private

    def camera_replay_name
      "#{Rails.env}_lesson_#{id}_camera_replay"
    end

    def board_replay_name
      "#{Rails.env}_lesson_#{id}_board_replay"
    end

    # 摄像头视频id
    def camera_video_vids
      channel_videos.where(video_for: ChannelVideo.video_fors['camera']).order(:begin_time).map(&:vid)
    end

    # 白板视频id
    def board_video_vids
      channel_videos.where(video_for: ChannelVideo.video_fors['board']).order(:begin_time).map(&:vid)
    end

    # 过期试听证
    def used_taste_tickets
      course.taste_tickets.pre_used.map(&:used!)
    end

    # 系统服务费
    def system_fee!(money, billing)
      system_money = Course::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      increase_cash_admin_account(system_money, billing)
      system_money
    end

    # 教师分成
    def teacher_fee!(money, billing)
      teacher_money = money * course.teacher_percentage.to_f / 100
      teacher.cash_account!.earning(teacher_money, billing.target, billing, "课程完成 - #{id} - #{name} - #{teacher_money}/#{money}")
      teacher_money
    end

    # 代理商分成
    # 代理商的分成打入workstation账户下
    def manager_fee!(money, billing)
      course.workstation.cash_account!.earning(money, billing.target, billing, "课程完成 - #{id} - #{name}")
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

    def new_live_session
      live_sessions.create(
        token: ::Encryption.md5("#{id}#{Time.now}").downcase,
        heartbeat_count: 0,
        duration: 0, # 单位(秒)
        heartbeat_at: 1,
        beat_step: LiveStudio::Lesson.beat_step
      )
    end

    # 今日课程立即是ready状态
    def data_preview
      self.status = class_date == Date.today ? 1 : 0
    end

    def data_confirm
      if start_time_hour || start_time_minute
        self.start_time = "#{start_time_hour}:#{start_time_minute}"
        self.end_time =  "#{(start_time_hour.to_i + (start_time_minute.to_i + duration_value.to_i) / 60)}:#{(start_time_minute.to_i + duration_value.to_i) % 60}"
      end
    end

    def update_course
      return unless course.present?
      first_class_date = course.lessons.order(:class_date).first.class_date
      course.update(class_date: first_class_date)
    end

    def play_records_params
      {
        course_id: course_id,
        lesson_id: id,
        start_time_at: live_start_at,
        end_time_at: live_end_at,
        tp: 'student'
      }
    end


    # 增加计数器
    def increment_course_counter(attribute)
      course.increment(attribute)
    end
  end
end