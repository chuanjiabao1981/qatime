module Permissions
  class TeacherPermission < BasePermission
    def initialize(user)
      allow :curriculums,[:index,:show]
      allow :home,[:index]
      allow :pictures,[:new,:create]
      allow :messages, [:index, :show]

      # need to be deleted

      allow :groups,[:index,:show]
      # end

      allow "teachers/curriculums",[:edit_courses_position,:update] do |curriculum|
        curriculum and curriculum.teacher_id == user.id
      end
      allow "teachers/courses",[:new,:create] do |curriculum|
        curriculum and curriculum.teacher_id == user.id
      end

      allow "teachers/courses",[:edit,:update] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:new,:create] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:edit,:update,:destroy] do |lesson|
        lesson and lesson.teacher_id == user.id
      end

      allow "teachers/videos",[:create]
      allow "teachers/videos",[:update] do |video|
        video and video.lesson.teacher_id == user.id
      end

      allow :topics,[:new,:create,:show]

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