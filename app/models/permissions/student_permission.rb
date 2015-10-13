module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :qa_faqs,[:index,:show]

      allow :home,[:index]
      allow :curriculums,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]


      allow :topics,[:new,:create] do |topicable|
        topicable_permission(topicable,user)
      end
      allow :topics,[:show]
      allow :topics,[:edit,:update,:destroy] do |topic|
        topic and topic.author_id == user.id
      end
      allow :messages, [:index, :show]
      allow :replies,[:create] do |topic|
        topic and topic.topicable and topicable_permission(topic.topicable,user)
      end
      allow :replies,[:edit,:update] do |reply|
        reply and reply.author_id == user.id
      end
      allow :pictures,[:new,:create]
      allow :videos,[:create]
      allow "students/faqs", [:index, :show]
      allow "students/faq_topics", [:show]
      allow :teaching_videos,[:show]

      allow :vip_classes, [:show] do |vip_class|
        vip_class
      end
      allow :questions,[:index,:student,:teachers,:new]
      allow :questions,[:create] do |learning_plan|
       learning_plan and learning_plan.student_id  == user.id
      end
      allow :questions,[:edit,:update] do |question|
        question and question.student_id == user.id
      end

      allow :questions,[:show] do |question|
        #暂时给所有的学生都开放
        question
        #只给问题的owner或者有valid的learning_plan
        #question and (question.student_id == user.id or  user.select_first_valid_learning_plan(question.vip_class))
      end


      allow :students,[:show,:edit,:update,:info,:teachers,
                       :questions,:topics,:customized_courses,
                       :customized_tutorial_topics,:homeworks,:solutions] do |student|
        student and student.id == user.id
      end
      allow :customized_courses,[:show,:topics,:homeworks,:solutions] do |customized_course|
        customized_course and customized_course.student_id == user.id
      end
      allow :customized_tutorials,[:show] do |customized_tutorial|
        customized_tutorial and customized_tutorial.customized_course.student_id == user.id
      end

      allow :homeworks ,[:show] do |homework|
        homework and homework.customized_course.student_id == user.id
      end

      allow :solutions,[:new,:create] do |solutionable|
        solutionable and solutionable_permission(solutionable,user)
      end

      allow :solutions,[:show,:edit,:update] do |solution|
        solution and solution.student_id == user.id
      end

      allow :exercises,[:show] do |exercise|
        exercise and exercise.customized_tutorial.customized_course.student.id == user.id
      end

      allow :tutorial_issues, [:new,:create] do |customized_tutorial|
        customized_tutorial and customized_tutorial.customized_course.student_id == user.id
      end
      allow :tutorial_issues, [:edit,:update] do |tutorial_issue|
        tutorial_issue and tutorial_issue.author_id == user.id
      end
      allow :tutorial_issues, [:show] do |tutorial_issue|
        tutorial_issue and tutorial_issue.author_id == user.id
      end


      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow 'students/home',[:main]
      allow 'students/recharge_records',[:index,:new,:create]
      allow 'students/courses',[:purchase]
      allow :lessons,[:show]
      allow :comments,[:create]
      allow :comments,[:edit,:update,:destroy] do |comment|
        comment and comment.author_id  == user.id
      end


      allow :tutorial_issue_replies,[:create] do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.student_id == user.id
      end

      allow :tutorial_issue_replies,[:edit,:update] do |tutorial_issue_reply|
        tutorial_issue_reply and tutorial_issue_reply.author_id == user.id
      end



    end
private
    def solutionable_permission(solutionable,user)
      if solutionable.instance_of? Homework
        solutionable.customized_course.student_id == user.id
      elsif solutionable.instance_of? Exercise
        solutionable.customized_tutorial.customized_course.student_id == user.id
      end
    end
    def topicable_permission(topicable,user)
      return false if topicable.nil?
      if topicable.instance_of? CustomizedCourse
        topicable.student_id == user.id
      elsif topicable.instance_of? CustomizedTutorial or topicable.instance_of? Homework
        topicable.customized_course.student_id == user.id
      elsif topicable.instance_of? Lesson
        ##TODO:: 这里应该是购买的学生才能看
        true
      end
    end
  end
end