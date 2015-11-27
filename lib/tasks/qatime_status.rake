task :qatime_status => :environment do

  Solution.all.each do |c|
    c.last_operator_id = c.student_id
    c.save
  end
  kk = []
  ActionRecord.all.each do |a|
    a = [a.id,a.actionable_id]
    kk.append(a)
  end

  kk.each do |k|
    a = Notification.find_by_notificationable_id(k[1])
    next unless a
    next if a.notificationable_type == "ActionRecord"

    b = ActionRecord.find(k[0])
    a.notificationable = b
    # a.to_json
    a.save
  end

  ActionRecord.all.each do |a|
    if a.actionable_type == 'Comment'
      a.type = 'CustomizedCourseCommentRecord'
      a.save
    end
  end

  Correction.all.each do |c|
    c.last_operator_id = c.teacher_id
    c.save
  end
end