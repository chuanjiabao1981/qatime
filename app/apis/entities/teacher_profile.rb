module Entities
  # 教师公开信息
  class TeacherProfile < Grape::Entity
    expose :name
    expose :desc
    expose :teaching_years
    expose :gender
    expose :grade
    expose :subject
    expose :category
    expose :province do |teacher|
      teacher.province.try(:name)
    end
    expose :city do |teacher|
      teacher.city.try(:name)
    end
    expose :avatar_url do |user,options|
      options[:size] == :info ? user.avatar_url(:ex_big) : user.avatar_url
    end
    expose :school do |s|
      s.school.try(:name)
    end
    expose :courses,using: Entities::LiveStudio::PublicCourse do |teacher|
      DataService::TeacherData.new(teacher).profile_courses
    end
    expose :interactive_courses,using: Entities::LiveStudio::PublicInteractiveCourse do |teacher|
      DataService::TeacherData.new(teacher).profile_interactive_courses
    end
    expose :video_courses,using: Entities::LiveStudio::PublicVideoCourse do |teacher|
      DataService::TeacherData.new(teacher).profile_video_courses
    end
    expose :icons do
      expose :course_can_refund do |teacher|
        true
      end
      expose :info_complete do |teacher|
        true
      end
      expose :teach_online do |teacher|
        true
      end
    end
  end
end
