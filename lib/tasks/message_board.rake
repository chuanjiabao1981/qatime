task :message_board => :environment do

  CustomizedCourse.all.each do |c|
    mb = c.build_customized_course_message_board
    mb.save
  end

end