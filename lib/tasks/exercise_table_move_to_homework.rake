task :exercise_table_move_to_homework => :environment do
  QaFile.where("qa_fileable_type='#{Exercise.to_s}'")
      .update_all({qa_fileable_type: ExerciseTmp.to_s})
  Picture.where("imageable_type='#{Exercise.to_s}'")
      .update_all({imageable_type:ExerciseTmp.to_s})
  Solution.where("solutionable_type='#{Exercise.to_s}'").update_all({solutionable_type:ExerciseTmp.to_s})
  Comment.where("commentable_type='#{Exercise.to_s}'")
      .update_all({commentable_type:ExerciseTmp.to_s})

  CustomizedTutorial.update_all({exercises_count:0})
  ExerciseTmp.all.each do |et|
      build_new_exercise(et)
  end
end

def build_new_exercise(et)
  e = Exercise.new
  e.token                   = et.token
  e.title                   = et.title
  e.content                 = et.content
  e.teacher_id              = et.teacher_id
  e.student_id              = et.student_id
  e.customized_course_id    = et.customized_course_id
  e.customized_tutorial_id  = et.customized_tutorial_id
  e.created_at              = et.created_at
  e.updated_at              = et.updated_at
  e.save
  puts "deal with qa_files #{et.id}"
  deal_with_has_many_qa_files(et,e)
  puts "deal_with pictures #{et.id}"

  deal_with_has_many_pictures(et,e)

  puts "deal with solutions #{et.id}"

  deal_with_has_many_solutions(et,e)
  puts "deal with comments #{et.id}"

  deal_with_has_many_comments(et,e)
end

def deal_with_has_many_qa_files(et,e)
  old_num = et.qa_files.length
  et.qa_files.each do |qf|
    qf.qa_fileable = e
    qf.save
  end
  e.reload
  new_num = e.qa_files.length
  puts old_num == new_num
  et.reload
  puts  et.qa_files.length == 0
end

def deal_with_has_many_pictures(et,e)
  old_num = et.pictures.length
  et.pictures.each do |p|
    p.imageable = e
    p.save
  end
  e.reload
  new_num = e.pictures.length
  puts old_num == new_num
  et.reload
  puts et.pictures.length == 0
end

def deal_with_has_many_solutions(et,e)
  old_num = et.solutions.length
  et.solutions.each do |s|
    s.solutionable  = e
    s.save
  end
  e.reload
  new_num = e.solutions.length
  puts old_num == new_num
  et.reload

  puts et.solutions.length == 0
  puts et.solutions_count == 0
  if et.solutions_count !=0
    puts et.to_json
    puts e.to_json
  end
  puts e.solutions_count == e.solutions.length
end

def deal_with_has_many_comments(et,e)
  old_num = et.comments.length
  et.comments.each do |c|
    c.commentable = e
    c.save
  end
  e.reload
  et.reload
  new_num = e.comments.length
  puts new_num == old_num
  puts et.comments.length == 0
  puts et.comments_count == 0
  puts e.comments_count == e.comments.length

end