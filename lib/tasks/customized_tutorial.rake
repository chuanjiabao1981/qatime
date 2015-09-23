task :customized_tutorial => :environment do
  CustomizedTutorial.all.each do |ct|
    if ct.qa_files.count > 0
      a = Exercise.new
      a.teacher = ct.teacher
      a.student = ct.customized_course.student
      a.title   = "随堂作业"
      a.content = ""
      a.customized_tutorial = ct
      a.save

      ct.qa_files.each do |f|
        f.qa_fileable = a
        f.save
      end
      a.reload
      # puts a.to_json(include: [:qa_files])

    end
  end
end