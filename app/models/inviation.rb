class Inviation < ActiveRecord::Base
  belongs_to :user
  belongs_to :inviter, class_name: User
  belongs_to :target, polymorphic: true

  enum status: {
    sent: 0, # 已发送
    accepted: 1, # 已接受
    refused: 2, # 已拒绝
    overdue: 3, # 已过期
    cancelled: 4 # 已取消
  }

  def status_text
    I18n.t("inviations.status.#{status}")
  end


  def expited_at_display
    second = Time.now.to_i - expited_at.to_i
    case
    when second >= 24.hours then "#{second/24.hours}天"
    when second < 24.hours && second >= 1.hours then "#{second/1.hours}小时#{(second%1.hours)/1.minutes}分"
    when second < 1.hours && second >= 1.minutes then "#{second/1.minutes}分#{(second%1.minutes)/1.minutes}秒"
    else "#{second}秒"
    end
  end

end
