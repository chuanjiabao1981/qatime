class NotificationSetting < Setting
  attr_accessor :notice
  attr_accessor :email
  attr_accessor :message

  private

  before_validation :update_value
  def update_value
    self.value = 0
    self.value += 4 if message
    self.value += 2 if email
    self.value += 1 if notice
  end

  after_find :read_value
  def read_value
    self.notice = value & 1 > 0
    self.email = value & 2 > 0
    self.message = value & 4 > 0
  end
end
