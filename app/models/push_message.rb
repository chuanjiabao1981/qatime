class PushMessage < ActiveRecord::Base
  serialize :result, Hash

  belongs_to :creator, polymorphic: true
  attr_accessor :customer, :assign_value, :send_type, :later_expire_time

  validates_presence_of :description, :ticker, :title, :text, :customer, :send_type, :after_open

  # 单播(unicast): device_tokens 指定单个设备号
  # 列播(listcast): device_tokens 指定多个设备号
  # 广播(broadcast): 向所有设备推送
  # 组播(groupcast): 根据filter指定向符合条件的用户推送
  # 自定义播(customizedcast): 向自定义用户推送 alias
  enum push_type: %w(unicast listcast broadcast groupcast customizedcast)
  enum display_type: %w(notification message)
  # go_app: 打开应用
  # go_url: 跳转到URL
  # go_activity: 打开特定的activity
  # go_custom: 用户自定义内容
  enum after_open: %w(go_app go_url go_activity) # go_url go_custom
  enum customer: %w(anyone student assign)
  enum status: %w(init pushing success failed)
  enum send_type: %w(now later)


  before_create :generate_attribute
  after_create :push_now!

  def push_type_text
    I18n.t("enums.push_message.push_type.#{push_type}")
  end

  def display_type_text
    I18n.t("enums.push_message.display_type.#{display_type}")
  end

  def after_open_text
    I18n.t("enums.push_message.after_open.#{after_open}")
  end

  def alias_type_text
    I18n.t("enums.push_message.alias_type.#{alias_type}")
  end

  def status_text
    I18n.t("enums.push_message.status.#{status}")
  end

  class << self
    def i18n_options_push_types
      push_types.map{|k,_| [I18n.t("enums.push_message.push_type.#{k}"), k]}
    end

    def i18n_options_display_types
      display_types.map{|k,_| [I18n.t("enums.push_message.display_type.#{k}"), k]}
    end

    def i18n_options_after_opens
      after_opens.map{|k,_| [I18n.t("enums.push_message.after_open.#{k}"), k]}
    end

    def i18n_options_alias_types
      [] || alias_types.map{|k,_| [I18n.t("enums.push_message.alias_type.#{k}"), k]}
    end
  end

  private
  def generate_attribute
    self.out_biz_no = Util.random_order_no
    push_type_logic
    send_type_logic
    after_open_logic
  end

  def push_type_logic
    case self.customer
      when 'anyone'
        self.push_type = 'broadcast'
      when 'student'
        self.push_type = 'customizedcast'
        self.alias_type = 'student'
      when 'assign'
        self.push_type = 'listcast'
        user = User.where('email = ? or login_mobile = ?', assign_value, assign_value).first
        user_devices = user.user_devices.map(&:token).uniq.compact
        raise Exception if user_devices.blank?
        self.device_tokens = user_devices.join(',')
      else
        raise Exception
    end
  end

  def send_type_logic
    case self.send_type
      when 'now'
        self.start_time = nil
      when 'later'
        self.expire_time = self.later_expire_time
      else
        raise Exception
    end
  end

  def after_open_logic
    if self.activity[0,4] == 'http'
      self.after_open = 'go_url'
      self.url = self.activity
      self.activity = nil
    end
  end

  def push_now!
    PushWorker.perform_async id
    pushing!
  end
end
