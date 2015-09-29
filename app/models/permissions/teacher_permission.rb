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
        # question != nil and question.answers_info.keys.find{|teacher_id|  teacher_id.to_i == user.id}
        question != nil and question.teachers and question.teacher_ids.include?(user.id)

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



      allow "teaching_videos",[:create,:show]


      allow :topics,[:new,:create] do |topicable|
        topicable_permission(topicable,user)
      end
      allow :topics,[:show]
      allow :topics,[:edit,:update,:destroy] do |topic|
        topic and topic.author_id == user.id
      end

      allow "teachers/home",[:main]

      allow :teachers,[:edit,:update,:show,:lessons_state,:students,:curriculums,
                       :info,:questions,:topics,:customized_courses,
                       :customized_tutorial_topics,:homeworks,:exercises] do |teacher|
        teacher and teacher.id == user.id
      end

      allow :replies,[:create] do |topic|
        topic and topic.topicable and topicable_permission(topic.topicable,user)
      end
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
      allow :customized_courses,[:show,:topics,:homeworks] do |customized_course|
        user and customized_course.teacher_ids.include?(user.id)
      end
      allow :customized_tutorials,[:new,:create] do |customized_course|
        user and customized_course.teacher_ids.include?(user.id)
      end
      allow :customized_tutorials,[:show,:edit,:update] do |customized_tutorial|
        user and (customized_tutorial.teacher_id == user.id or
                    customized_tutorial.customized_course.teacher_ids.include?(user.id))
      end

      allow :homeworks,[:new,:create] do |customized_course|
        customized_course and customized_course.teacher_ids.include?(user.id)
      end

      allow :homeworks,[:show,:edit,:update] do |homework|
        homework and homework.teacher_id == user.id or homework.customized_course.teacher_ids.include?(user.id)
      end

      allow :solutions,[:show] do |solution|
        solution and solution_permission(solution,user)
      end

      allow :corrections,[:create] do |solution|
        solution and solution_permission(solution,user)
      end

      allow :corrections,[:edit,:update] do |correction|
        correction and correction.teacher_id == user.id
      end

      allow :exercises,[:new,:create] do |customized_tutorial|
        customized_tutorial and customized_tutorial.teacher_id == user.id
      end

      allow :exercises,[:show,:edit,:update] do |exercise|
        exercise and
            (exercise.teacher_id == user.id or
                exercise.customized_tutorial.customized_course.teacher_ids.include?(user.id))
      end

    end
private

    def solution_permission(solution,user)
      if solution.solutionable.instance_of? Homework
        solution.solutionable.customized_course.teacher_ids.include?(user.id)
      elsif solution.solutionable.instance_of? Exercise
        solution.solutionable.customized_tutorial.teacher_id == user.id or
            solution.solutionable.customized_tutorial.customized_course.teacher_ids.include?(user.id)
      end
    end
    def topicable_permission(topicable,user)
      return false if topicable.nil?
      if topicable.instance_of? CustomizedCourse
        topicable.teacher_ids.include?(user.id)
      elsif topicable.instance_of? CustomizedTutorial
        topicable.teacher_id == user.id or topicable.customized_course.teacher_ids.include?(user.id)
      elsif topicable.instance_of? Homework
        topicable.customized_course.teacher_ids.include?(user.id)
      elsif topicable.instance_of? Lesson
        topicable.teacher_id == user.id
      end
    end
  end
end