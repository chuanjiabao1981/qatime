class AddResolvedAtToLiveStudioTasks < ActiveRecord::Migration
  def change
    add_column :live_studio_tasks, :resolved_at, :datetime
    add_column :live_studio_tasks, :published_at, :datetime

    # 提问回答时间
    LiveStudio::Answer.includes(:question).find_each do |answer|
      question = answer.question
      question.resolved_at = answer.created_at
      question.save
    end

    # 作业批改时间
    LiveStudio::Correction.includes(:student_homework).find_each do |correction|
      student_homework = correction.student_homework
      student_homework.resolved_at = correction.created_at
      student_homework.save
    end

    # 学生作业提交时间
    LiveStudio::StudentHomework.find_each do |student_homework|
      student_homework.published_at = student_homework.created_at
      student_homework.save
    end
  end
end
