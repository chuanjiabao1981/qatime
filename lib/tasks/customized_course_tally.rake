task :customized_course_tally => :environment do
  Teacher.all.each do |teacher|
    if teacher
      teacher.keep_account
    end
  end
end