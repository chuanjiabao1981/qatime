task :customized_course_add_price => :environment do
  CustomizedCourse.all.each do |customized_course|
    if customized_course and customized_course.nil?
      customized_course.price = 54
      customized_course.teacher_price = 54
      customized_course.heighten!
    end
  end
end