task :learning_plan_merge => :environment do
  dry_run = false
  learning_plan_merge(dry_run)
  question_merge(dry_run)
  old_learning_plan_destroy(dry_run)
end

def old_learning_plan_destroy(dry_run)
  LearningPlan.all.each do |learning_plan|
    if learning_plan.duration_type == '新建'
    else
      learning_plan.destroy
    end
  end
end
def question_merge(dry_run)
  Question.all.each do |question|
    message =  "#{question.learning_plan.student.name} #{question.learning_plan.vip_class.category} #{question.learning_plan.vip_class.subject} #{question.learning_plan.duration_type}"
    ttt = {student_id: question.learning_plan.student_id,
           vip_class_id: question.learning_plan.vip_class_id,
           duration_type: "新建"
          }
    puts message
    r   = LearningPlan.where(ttt)
    if r.size == 1
      new_learning_plan = r.first
      question.learning_plan = new_learning_plan
      if new_learning_plan.teachers.size > 0
        new_learning_plan.teachers.each do |teacher|
          question.teachers << teacher
        end
        question.save unless dry_run
      else
        puts "new learning plan has no teacher !!!"
      end
    else
      puts r.size
      puts message
      puts "fuck here ......."
    end
  end
end
def learning_plan_merge(dry_run)
  LearningPlan.all.each do |learning_plan|

    # if learning_plan.student_id == 237 and learning_plan.vip_class_id == 4
    #   puts "#{learning_plan.student.name} #{learning_plan.vip_class.category} #{learning_plan.vip_class.subject}"
    # end
    ttt = {student_id:    learning_plan.student_id,
           vip_class_id:  learning_plan.vip_class_id,
           duration_type: "新建"
    }
    if LearningPlan.where(ttt).size == 0
      a = LearningPlan.new(ttt)
      a.begin_at  = Time.now
      a.end_at    = Time.now
      a.teachers  = learning_plan.teachers
      a.save unless dry_run
      # if learning_plan.student_id == 237 and learning_plan.vip_class_id == 4
      #   puts "#{learning_plan.student.name} #{learning_plan.vip_class.category} #{learning_plan.vip_class.subject}"
      #   puts a.valid?
      #   puts a.errors.full_messages
      # end
      # puts a.to_json
      # puts a.teacher_ids

    elsif LearningPlan.where(ttt).size == 1
      a = LearningPlan.where(ttt).first
      learning_plan.teachers.each do |teacher|
        if a.teacher_ids and not a.teacher_ids.include?(teacher.id)
          a.teachers << teacher
        end
      end
      a.save unless dry_run
      # puts a.to_json
    else
      puts "not valid!!!!!!!"
      exit
    end
    # if learning_plan.student_id == 237 and learning_plan.vip_class_id == 4
    #   puts LearningPlan.where(ttt).size
    # end
  end
  VipClass.all.each do |vip_class|
    Student.all.each do |student|
      t = []
      LearningPlan.where({student_id: student.id,vip_class_id: vip_class.id}).where.not(duration_type: "新建").each do |learning_plan|
        t << learning_plan.teacher_ids
      end
      x = LearningPlan.where({student_id: student.id,vip_class_id: vip_class.id,duration_type: "新建"})
      if t.empty?
        if x.size == 0
          #puts "both is empty"
        else
          puts "fuck error here 1"
        end
      elsif x.size == 1
        x = x.first
        if t.uniq.sort == x.teacher_ids.uniq.sort
          if x.teacher_ids.uniq.size == x.teacher_ids
            puts " OK "
          else
            puts "fuck error here 2"
          end
        end
      else
        puts "not valid ! fuck"
        puts x.size
        puts t
        puts student.to_json
        puts vip_class.to_json
      end
    end
  end
end