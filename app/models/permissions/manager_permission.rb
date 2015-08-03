module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow :qa_faqs,[:index,:show]

      allow "managers/register_codes",[:index,:create,:new]
      allow "managers/lessons",[:state,:update]

      allow "managers/home",[:main]

      allow :vip_classes,[:show]
      allow :questions,[:index,:show,:student,:teacher]
      allow :teaching_videos,[:show]
      allow :students,[:index,:search,:show,:edit,:create,:update,:info,:teachers,:customized_courses]
      allow :home,[:index]
      allow :schools,[:index,:new,:create,:show,:edit,:update]
      allow :teachers,[:index,:new,:create,:show,:edit,:update,:search,:pass,:unpass,:students,:curriculums,:info,:questions,:topics,:lessons_state,:customized_courses]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index,:edit,:update]
      allow :courses,[:show]
      allow :comments,[:create]
      allow :comments,[:edit,:update] do |comment|
        comment
      end

      allow :customized_courses, [:show,:edit,:update,:teachers] do |customized_course|
        user and customized_course
      end

      allow :customized_courses ,[:new,:create] do |student|
        user and student
      end

      allow :customized_tutorials, [:show]

      allow :sessions,[:destroy]

    end
  end
end