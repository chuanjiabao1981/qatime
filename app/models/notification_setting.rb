class NotificationSetting < Setting
  def notice
    @notice = (value.to_i & 1 > 0) if @notice.nil?
    @notice
  end

  def notice=(notice)
    @notice = notice.to_i > 0
  end

  def email
    @email = (value.to_i & 2 > 0) if @email.nil?
    @email
  end

  def email=(email)
    @email = email.to_i > 0
  end

  def message
    @message = (value.to_i & 4 > 0) if @message.nil?
    @message
  end

  def message=(message)
    @message = message.to_i > 0
  end

  def before_hours
    @before_hours ||= ext.to_i / 60
  end

  def before_hours=(hours)
    @before_hours = hours.to_i
  end

  def before_minutes
    @before_minutes ||= ext.to_i % 60
  end

  def before_minutes=(minutes)
    @before_minutes = minutes.to_i
  end

  def self.default
    # 默认邮件、短信都通知
    new(value: 7, ext: 30)
  end

  private

  before_validation :update_value
  def update_value
    self.value = 0
    self.value += 1 if notice
    self.value += 2 if email
    self.value += 4 if message
  end

  before_validation :update_ext
  def update_ext
    self.ext = before_hours * 60 + before_minutes
  end
end
