task :examination => :environment do

  Examination.where("work_type is null").update_all({type: Homework.to_s})
  Examination.where(work_type: "exercise").update_all({type: Exercise.to_s})
end