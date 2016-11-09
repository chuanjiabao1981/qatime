module InvitationsHelper

  def distance_of_expited_at(expited_at)
    second = expited_at.to_i - Time.now.to_i
    case
    when second >= 24.hours then "#{second/24.hours}#{I18n.t 'invitations.day'}"
    when second < 24.hours && second >= 1.hours then "#{second/1.hours}#{I18n.t 'invitations.hour'}#{(second%1.hours)/1.minutes}#{I18n.t 'invitations.minute'}"
    when second < 1.hours && second >= 1.minutes then "#{second/1.minutes}#{I18n.t 'invitations.minute'}#{(second%1.minutes)/1.minutes}#{I18n.t 'invitations.second'}"
    when second < 1.minutes && second >= 0 then "#{second}#{I18n.t 'invitations.second'}"
    else I18n.t "invitations.status.expired"
    end
  end
end
