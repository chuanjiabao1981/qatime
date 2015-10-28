task :customized_course_add_price => :environment do

  CustomizedCourse.all.each do |customized_course|
    if customized_course and customized_course.price.nil?
      teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(customized_course.category, "heighten")
      customized_course.platform_price = platform_price
      customized_course.teacher_price = teacher_price
      customized_course.heighten!
    end
  end

  [CustomizedTutorial, Correction, CourseIssueReply, TutorialIssueReply].each do |s|
    s.all.each do |object|
      if object
        if object.platform_price.nil? or object.teacher_price.nil?
          object.set_customized_course_prices
          object.save!
        end
      end
    end
  end
end