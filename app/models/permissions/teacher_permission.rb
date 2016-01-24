module Permissions
  class TeacherPermission < UserPermission
    STATE_EVENTS = Examination.state_machines[:state].events.map(&:name) - [:handle]

    def initialize(user)
      super(user)
      allow :qa_faqs,[:index,:show]

      allow :curriculums,[:index,:show]
      allow :home,[:index]
      allow :pictures,[:new,:create]
      allow :pictures,[:destroy] do |picture|
        picture and picture.author and picture.author_id == user.id
      end
      allow :messages, [:index, :show]



      allow :questions,[:index,:show,:teacher]
      allow :questions,[:show]
      allow :answers,[:create] do |question|
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
                       :customized_tutorial_topics,:homeworks,:solutions,:notifications] do |teacher|
        teacher and teacher.id == user.id
      end

      allow :replies,[:create] do |topic|
        topic and topic.topicable and topicable_permission(topic.topicable,user)
      end
      allow :replies,[:edit,:update] do |reply|
        reply and reply.status == "open" and reply.author_id == user.id
      end

      allow :lessons,[:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow "teachers/faqs", [:index, :show]
      allow "teachers/faq_topics", [:show]
      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow :comments,[:create,:show]
      allow :comments,[:edit,:update,:destroy] do |comment|
        comment and comment.author_id  == user.id
      end
      allow :customized_courses,[:show,:topics,:homeworks,:solutions,:action_records] do |customized_course|
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

      allow :homeworks,[:show,:edit,:update]+STATE_EVENTS do |homework|
        homework and homework.teacher_id == user.id or homework.customized_course.teacher_ids.include?(user.id)
      end

      allow :solutions,[:show]+STATE_EVENTS do |solution|
        solution and solution.examination.response_teachers.include?(user)
      end


      allow :corrections,[:create,:show] do |solution|
        solution and solution.examination and solution.examination.response_teachers.include?(user)
      end

      allow :corrections,[:edit,:update] do |correction|
        correction and correction.status == "open" and correction.teacher_id == user.id
      end

      allow :exercises,[:new,:create] do |customized_tutorial|
        customized_tutorial  and customized_tutorial.teacher_id == user.id
      end

      allow :exercises,[:show,:edit,:update]+STATE_EVENTS do |exercise|
        exercise and
            (exercise.teacher_id == user.id or
                exercise.customized_tutorial.customized_course.teacher_ids.include?(user.id))
      end

      allow :tutorial_issues,[:show]+STATE_EVENTS do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.teacher_ids.include?(user.id)
      end

      allow :tutorial_issue_replies,[:show,:create] do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.teacher_ids.include?(user.id)
      end
      allow :tutorial_issue_replies,[:edit,:update] do |tutorial_issue_reply|
        tutorial_issue_reply and tutorial_issue_reply.author_id == user.id
      end

      allow :course_issues,[:show]+STATE_EVENTS do |course_issue|
        course_issue and course_issue.customized_course.teacher_ids.include?(user.id)
      end

      allow :course_issue_replies,[:create] do |course_issue|
        course_issue and course_issue.customized_course.teacher_ids.include?(user.id)
      end
      allow :course_issue_replies,[:edit,:update] do |course_issue_reply|
        course_issue_reply and course_issue_reply.author_id == user.id and course_issue_reply.status == "open"
      end
      allow :course_issue_replies,[:show] do |course_issue_reply|
        course_issue_reply and course_issue_reply.customized_course.teacher_ids.include?(user.id)
      end



      #######begine course library permission###############
      allow "course_library/courses",[:available_customized_courses_for_publish,:publish,:customized_tutorials] do |course|
        true
      end
      #######end course library permission##################

    end
private

    def topicable_permission(topicable,user)
      return false if topicable.nil?
      if topicable.instance_of? Lesson
        topicable.teacher_id == user.id
      end
    end
  end
end