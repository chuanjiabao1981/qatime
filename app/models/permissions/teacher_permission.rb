module Permissions
  class TeacherPermission < BasePermission
    def initialize(user)
      allow :groups,[:index,:show]
      allow :home,[:index]
      allow "teachers/courses",[:new,:create] do |group|
        group and group.teacher_id == user.id
      end
      allow "teachers/courses",[:edit,:update] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:new,:create] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:edit,:update] do |lesson|
        lesson and lesson.teacher_id == user.id
      end

      allow "teachers/videos",[:create]
      allow "teachers/videos",[:update] do |video|
        video and video.lesson.teacher_id == user.id
      end

      allow "teachers/home",[:main]

      allow "teachers/registrations",[:edit,:update,:show]

      allow :courses,[:show]
      allow :sessions,[:destroy]

    end
  end
end