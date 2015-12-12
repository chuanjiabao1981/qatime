task :qatime_status => :environment do

  Solution.all.each do |c|
    c.last_operator_id = c.student_id
    c.save
  end



  p4 = []
  ActionRecord.all.each do |a|
    b = a.actionable
    # lp = [b.customized_course_action_records.size,Notification.where(notificationable_id: b.id).size]
    ll1 = ActionRecord.where(actionable_id: b.id).order(:created_at => :desc).ids
    ll2 = Notification.where(notificationable_id: b.id).order(:created_at => :desc).ids
    l1 = ll1.size
    l2 = ll2.size
    # puts "#{l1}-#{l2}"
    if l1 != l2
      puts "fuck ======================================";
    end
    p4.append([ll1,ll2])
  end
  p4.each do |p|
    p[1].zip(p[0]).each do |a,b|
      ar = Notification.find(a)
      br = ActionRecord.find(b)
      ar.notificationable = br
      ar.save
    end
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
    t.last_operator_id = t.author_id
    t.save
  end

  Topic.all.each do |t|
    replies = t.replies.order(:created_at => :asc)
    #Topic只能被Teacher进行回复所以last_operator一定是teacher
    if replies.length > 0
      t.first_handled_at  = replies[0].created_at
      t.last_handled_at   = replies[-1].created_at
      t.completed_at      = replies[-1].created_at
      t.state             = :completed
      t.save!
    end
  end

end