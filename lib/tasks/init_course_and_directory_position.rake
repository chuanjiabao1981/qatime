task :init_directory_and_course_position => :environment do
  CourseLibrary::Directory.all.each do |directory|
    directory.courses.order('created_at asc').each_with_index  do |course, index|
      course.position_id = 0
      course.save
    end
    directory.children.order('created_at asc').each_with_index  do |child, index|
      child.position_id = 0
      child.save
    end
  end
  CourseLibrary::Directory.all.each do |directory|
    directory.courses.order('created_at asc').each_with_index  do |course, index|
      course.set_list_position(index+1)
    end
    directory.children.order('created_at asc').each_with_index  do |child, index|
      child.set_list_position(index+1)
    end
  end
end