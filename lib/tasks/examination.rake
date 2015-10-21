task :examination => :environment do

  Examination.where("work_type is null").update_all({type: Homework.to_s})
  Examination.where(work_type: "exercise").update_all({type: Exercise.to_s})
  QaFile.where(qa_fileable_type: Exercise.to_s).update_all(qa_fileable_type: Examination.to_s)
  QaFile.where(qa_fileable_type: Homework.to_s).update_all(qa_fileable_type: Examination.to_s)

  #关系
  #counter
  #has_many
end