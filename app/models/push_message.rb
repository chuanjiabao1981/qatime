class PushMessage < ActiveRecord::Base
  serialize :result, Hash

  belongs_to :creator, polymorphic: true
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
  enum after_open: %w(go_app go_url go_activity go_custom)
  # 推送对象: 目前只有学生
  enum alias_type: %w(student)
  enum status: %w(init pushing success failed)

  before_create :generate_out_biz_no

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
      alias_types.map{|k,_| [I18n.t("enums.push_message.alias_type.#{k}"), k]}
    end
  end

  private
  def generate_out_biz_no
    self.out_biz_no = Util.random_order_no
  end
end
