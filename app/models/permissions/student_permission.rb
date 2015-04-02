module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
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

      allow :vip_classes, [:show] do |vip_class|
        vip_class
      end
      allow :questions,[:index,:show]
      allow :questions,[:new,:create] do |vip_class|
        #通过validate 阻止一个没有vip_class的question
        if vip_class == "dummy"
          next true
        elsif user.select_a_valid_learning_plan(vip_class)
          next true
        end
        next false
      end
      allow :questions,[:edit,:update] do |question|
        question and question.student_id == user.id
      end


      allow :students,[:show,:edit,:update] do |student|
        student and student.id == user.id
      end
      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow 'students/home',[:main]
      allow 'students/registrations',[:edit,:update]
      allow 'students/recharge_records',[:index,:new,:create]
      allow 'students/courses',[:purchase]
    end
  end
end