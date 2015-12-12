task :issue_and_reply => :environment do

  Topic.where("topicable_type = 'CustomizedTutorial'").each do |t|
    t.type = TutorialIssue.to_s
    t.customized_tutorial_id = t.topicable_id
    t.save
    Reply.where("topic_id = ?",t.id).each do |r|
      r.type = TutorialIssueReply
      r.save
    end
  end

  Topic.where("topicable_type = 'CustomizedCourse'").each do |t|
    t.type = CourseIssue.to_s
    t.save
    Reply.where("topic_id = ?",t.id).each do |r|
      r.type = CourseIssueReply
      r.save
    end
  end
end