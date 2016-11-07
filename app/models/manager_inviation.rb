class ManagerInviation < Inviation

  def created_date_display
    created_at.strftime('%F %T')
  end

end
