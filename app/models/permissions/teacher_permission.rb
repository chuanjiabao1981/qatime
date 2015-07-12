module Permissions
  class TeacherPermission < BasePermission
    def initialize(user)
      allow :qa_faqs,[:index,:show]

      allow :curriculums,[:index,:show]
      allow :home,[:index]
      allow :pictures,[:new,:create]
      allow :messages, [:index, :show]



      allow :questions,[:index,:show,:teacher]
      allow :questions,[:show]
      allow :answers,[:create] do |question|
        question != nil and question.answers_info.keys.find{|teacher_id|  teacher_id.to_i == user.id}
      end
      allow :answers,[:edit,:update] do |answer|
        answer and answer.teacher_id == user.id
      end
      allow :vip_classes,[:show]

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

      allow "videos",[:create,:show]
      allow "videos",[:update] do |video|
        video and video.author_id == user.id
      end


      ##TODO:: delete
      # allow "teachers/videos",[:create]
      # allow "teachers/videos",[:update] do |video|
      #   video and video.author_id == user.id
      # end
      ##delte end

      allow "teaching_videos",[:create,:show]


      allow :topics,[:new,:create,:show]
      allow :topics,[:edit,:update,:destroy] do |topic|
        topic and topic.author_id == user.id
      end

      allow "teachers/home",[:main]

      allow :teachers,[:edit,:update,:show,:lessons_state,:students,:curriculums,:info,:questions,:topics,:customized_courses] do |teacher|
        teacher and teacher.id == user.id
      end

      allow :replies,[:create]
      allow :replies,[:edit,:update,:destroy] do |reply|
        reply and reply.author_id == user.id
      end

      allow :lessons,[:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow "teachers/faqs", [:index, :show]
      allow "teachers/faq_topics", [:show]
      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow :comments,[:create]
      allow :comments,[:edit,:update,:destroy] do |comment|
        comment and comment.author_id  == user.id
      end

    end
  end
end