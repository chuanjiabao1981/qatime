class NotificationSetting < Setting
  attr_accessor :notice
  attr_accessor :email
  attr_accessor :message

  attr_accessor :before_hours
  attr_accessor :before_minutes

  private

  before_validation :update_value
  def update_value
    self.value = 0
    self.value += 4 if message && message > 0
    self.value += 2 if email && email > 0
    self.value += 1 if notice && notice > 0
  end

  before_validation :update_ext
  def update_ext
    self.ext = 0
    self.ext += before_hours * 60
    self.ext += before_minutes
  end

  after_find :read_value
  def read_value
    self.notice = value & 1
    self.email = value & 2
    self.message = value & 4
  end

  after_find :read_ext
  def read_ext
    self.ext = value & 1 > 0
    self.before_hours = ext.to_i / 60
    self.before_minutes = ext.to_i % 60
  end
end
