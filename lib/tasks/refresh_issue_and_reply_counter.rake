task :refresh_issue_and_reply_counter => :environment do

    CustomizedCourse.all.each do |c|
      CustomizedCourse.reset_counters(c.id, :tutorial_issues)
      CustomizedCourse.reset_counters(c.id, :course_issues)
    end

end