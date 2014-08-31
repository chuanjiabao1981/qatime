module Permissions
  class TeacherPermission < BasePermission
    def initialize(user)
      allow :groups,[:index,:show]
      allow :home,[:index]
      allow :pictures,[:new,:create]
      allow :messages, [:index, :show]

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
      allow "teachers/faqs", [:index, :show]
      allow "teachers/faq_topics", [:show]
      allow :faqs, [:show]
      allow :faq_topics, [:show]

    end
  end
end