task :customized_course_add_price => :environment do

  CustomizedCourse.all.each do |customized_course|
    if customized_course and customized_course.price.nil?
      customized_course.price = 54
      customized_course.teacher_price = 54
      customized_course.heighten!
    end
  end

  [CustomizedTutorial, Correction, Reply].each do |s|
    s.all.each do |object|
      if object and object.price.nil?
          object.price = 54
          object.teacher_price = 54
          object.save!
       end
    end
  end

end