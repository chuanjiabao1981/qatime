task :teaching_program_init => :environment do

  dry_run = false
  puts "########### Teaching Program ##################"
  GroupType.all.each do |group_type|
    teaching_program = TeachingProgram.new
    teaching_program.id = group_type.id
    teaching_program.name = group_type.name
    teaching_program.category = "高中"
    if group_type.grade == 's1'
      teaching_program.grade = "高一"
    else
      teaching_program.grade = "高二"
    end
    teaching_program.subject = APP_CONSTANT["english"].key(group_type.subject)

    catalogues = group_type.group_catalogues.order(:index)

    teaching_program.content = {"chapters" => catalogues.map {|c| c.name}}

    if not teaching_program.valid?
      puts teaching_program.errors.messages, group_type.id
    else
      teaching_program.save if not dry_run
    end
  end

  puts "########### Curriculum ##################"
  Group.all.each do |group|
    curriculum = Curriculum.new
    curriculum.id = group.id
    curriculum.teacher_id = group.teacher_id
    curriculum.teaching_program_id = group.group_type_id
    #curriculum.courses_count = group.courses_count
    #curriculum.lessons_count = group.courses.reduce(0) {|a,v| a+v.lessons_count}

    if not curriculum.valid?
      puts curriculum.valid?,curriculum.lessons_count,curriculum.courses_count
    else
      curriculum.save if not dry_run
    end
  end

  puts "########### Course ##################"

  Course.all.each do |course|
    if not course.group_catalogue
      puts course.id.to_s + "##########+++++"
      next
    end

    course.chapter         = course.group_catalogue.name
    course.curriculum_id   = course.group_id
    if not course.valid?
      puts course.errors.messages, course.id
    else
      course.save if not dry_run
    end
  end

  puts "########### Lesson ##################"

  Lesson.all.each do |lesson|
    lesson.curriculum_id = lesson.group_id
    if not lesson.valid?
      puts lesson.errors.messages, lesson.id
    else
      lesson.save if not dry_run
    end
  end

  puts "########### Teacher ##################"


  Teacher.all.each do |teacher|
    if not teacher.groups.first
      puts teacher.id
      next
    end
    teacher.subject   = APP_CONSTANT["english"].key(teacher.groups.first.group_type.subject)
    teacher.category  = '高中'

    if not teacher.valid?
      puts teacher.errors.messages, teacher.id
    else
      teacher.save if not dry_run
    end
  end


  puts "########### Topic ##################"
  Topic.all.each do |topic|
    topic.curriculum_id = topic.group_id
    if not topic.valid?
      puts topic.id
    end
    topic.save if not dry_run
  end

end