task :set_creator_id_to_customized_courses => :environment do
  manager = Manager.where(email:"machengke@qatime.cn").first

  CustomizedCourse.all.each do |customized_course|
    if customized_course and customized_course.creator_id.nil?
      customized_course.creator_id = manager.id
      customized_course.save
    end
  end
end