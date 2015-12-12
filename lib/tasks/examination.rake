task :examination => :environment do

  Examination.where("work_type is null").update_all({type: Homework.to_s})
  Examination.where(work_type: "exercise").update_all({type: Exercise.to_s})
  QaFile.where(qa_fileable_type: Exercise.to_s).update_all(qa_fileable_type: Examination.to_s)
  QaFile.where(qa_fileable_type: Homework.to_s).update_all(qa_fileable_type: Examination.to_s)
  Picture.where(imageable_type: Exercise.to_s).update_all(imageable_type: Examination.to_s)
  Picture.where(imageable_type: Homework.to_s).update_all(imageable_type: Examination.to_s)


  Solution.where("solutionable_id is not null").connection.execute("update solutions set examination_id=solutionable_id")
  Solution.all.each do |s|
    next unless s and s.examination
    s.type ="#{s.examination.class.to_s}Solution"
    s.save
    puts s.type
  end

  Correction.connection.execute("update corrections set examination_id=homework_id")

  Correction.all.each do |c|
    c.type = "#{c.examination.class.to_s}Correction"
    c.save
    puts c.type
  end


  Examination.all.each do |e|
    Examination.reset_counters(e.id, :solutions)
    Examination.reset_counters(e.id, :corrections)
  end

  Solution.all.each do |s|
    Solution.reset_counters(s.id,:corrections)
  end

end