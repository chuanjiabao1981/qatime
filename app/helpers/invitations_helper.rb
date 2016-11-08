module InvitationsHelper

  def distance_of_expited_at(expited_at)
    second = expited_at.to_i - Time.now.to_i
    case
    when second >= 24.hours then "#{second/24.hours}天"
    when second < 24.hours && second >= 1.hours then "#{second/1.hours}小时#{(second%1.hours)/1.minutes}分"
    when second < 1.hours && second >= 1.minutes then "#{second/1.minutes}分#{(second%1.minutes)/1.minutes}秒"
    when second < 1.minutes && second >= 0 then "#{second}秒"
    else I18n.t "invitations.status.expired"
    end
  end
end
