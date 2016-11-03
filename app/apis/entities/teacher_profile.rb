module Entities
  # 教师公开信息
  class TeacherProfile < Grape::Entity
    expose :name
    expose :desc
    expose :teaching_years
    expose :gender
    expose :grade
    expose :subject
    expose :avatar_url do |user,options|
      options[:size] == :info ? user.avatar_url(:ex_big) : user.avatar_url
    end
    expose :school do |s|
      s.school.try(:name)
    end
    expose :courses,using: Entities::LiveStudio::PublicCourse do |user|
      user.live_studio_courses.where('status > ?', ::LiveStudio::Course.statuses[:init])
    end
  end
end
