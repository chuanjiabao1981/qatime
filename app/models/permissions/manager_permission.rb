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
      allow :students,[:index,:search,:show,:edit,:create,:update,:info,:teachers]
      allow :home,[:index]
      allow :schools,[:index,:new,:create,:show,:edit,:update]
      allow :teachers,[:index,:new,:create,:show,:edit,:update,:search,:pass,:unpass,:students,:curriculums,:info,:questions,:topics,:lessons_state]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index,:edit,:update]
      allow :courses,[:show]
      allow :comments,[:create]
      allow :comments,[:edit,:update] do |comment|
        comment
      end

      allow :sessions,[:destroy]

    end
  end
end