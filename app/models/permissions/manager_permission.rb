module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow "managers/register_codes",[:index,:create,:new]
      allow "managers/lessons",[:state,:update]

      allow "managers/home",[:main]

      allow :vip_classes,[:show]
      allow :questions,[:index,:show,:student,:teacher]
      allow :teaching_videos,[:show]
      allow :students,[:index,:search,:show,:edit,:create,:update]
      allow :home,[:index]
      allow :schools,[:index,:new,:create,:show,:edit,:update]
      allow :teachers,[:index,:new,:create,:show,:edit,:update,:search]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index,:edit,:update]
      allow :courses,[:show]

      allow :sessions,[:destroy]

    end
  end
end