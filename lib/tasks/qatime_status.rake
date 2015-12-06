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

  Solution.all.each do |s|
    if not s.first_handle_created_at.nil? and s.first_handled_at.nil?
      s.first_handled_at      = s.first_handle_created_at
      s.last_handled_at       = s.last_handle_created_at
      s.completed_at          = s.last_handle_created_at
      s.state                 = :completed
      s.save
    end
  end

  Examination.all.each do |e|
    e.last_operator_id = e.teacher_id
    e.save
  end

  Examination.all.each do |e|
    solutions = e.solutions.order(:created_at => :asc)

    if solutions.length > 0
      e.first_handled_at  = solutions[0].created_at
      e.last_handled_at   = solutions[-1].created_at
      e.completed_at      = solutions[-1].created_at
      all_competed        = true
      solutions.each do |solution|
        if not solution.completed?
          all_competed    = false
        end
      end
      if all_competed
        e.state             = :completed
      else
        e.state             = :in_progress
      end
      e.save
    end
  end

  CustomizedTutorial.all.each do |c|
    c.last_operator_id = c.teacher_id
    c.save
  end

  CustomizedCourseMessage.all.each do |c|
    c.last_operator_id = c.author_id
    c.save
  end

  CustomizedCourseMessageReply.all.each do |c|
    c.last_operator_id = c.author_id
    c.save
  end

  Reply.all.each do |r|
    r.last_operator = r.author
    r.save
  end

  Topic.all.each do |t|
    t.last_operator_id = t.author
    t.save
  end

end