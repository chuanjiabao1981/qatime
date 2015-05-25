module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :qa_faqs,[:index,:show]

      allow :home,[:index]
      allow :curriculums,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow :topics,[:new,:create,:show]
      allow :messages, [:index, :show]
      allow :replies,[:create]
      allow :pictures,[:new,:create]
      allow :videos,[:create]
      allow "students/faqs", [:index, :show]
      allow "students/faq_topics", [:show]
      allow :teaching_videos,[:show]

      allow :vip_classes, [:show] do |vip_class|
        vip_class
      end
      allow :questions,[:index,:student]
      allow :questions,[:new,:create] do |vip_class|
        #通过validate 阻止一个没有vip_class的question
        if vip_class == "dummy"
          next true
        elsif user.select_first_valid_learning_plan(vip_class)
          next true
        end
        next false
      end
      allow :questions,[:edit,:update] do |question|
        question and question.student_id == user.id
      end

      allow :questions,[:show] do |question|
        #问题的owner或者有valid的learning_plan
        question and (question.student_id == user.id or  user.select_first_valid_learning_plan(question.vip_class))
      end


      allow :students,[:show,:edit,:update,:info,:teachers,:questions,:topics] do |student|
        student and student.id == user.id
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
    end
  end
end